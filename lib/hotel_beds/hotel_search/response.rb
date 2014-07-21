require "active_model/errors"
require "hotel_beds/model/hotel"
require "hotel_beds/model/available_room"
require_relative "room_grouper"

module HotelBeds
  module HotelSearch
    class Response
      attr_accessor :request, :headers, :body, :errors
      private :request=, :headers=, :body=, :errors=

      def initialize(request, response)
        self.request = request
        self.headers = response.header
        self.body = Nokogiri::XML(response.body.fetch(:get_hotel_valued_avail))
        self.errors = ActiveModel::Errors.new(self).tap do |errors|
          if response.http_error?
            errors.add(:base, "HTTP error")
          elsif response.soap_fault?
            errors.add(:base, "SOAP error")
          elsif !response.success?
            errors.add(:base, "Request failed")
          end

          body.css("ErrorList Error").each do |error|
            errors.add(:base, [
              (sm = error.at_css("Message")) && sm.content,
              (dm = error.at_css("DetailedMessage")) && dm.content
            ].compact.join("\n"))
          end
        end
        freeze
      end

      def inspect
        "<#{self.class.name} errors=#{errors.inspect} headers=#{headers.inspect} body=#{body.to_s}>"
      end

      def current_page
        if data = pagination_data
          Integer(data.attr("currentPage"))
        else
          0
        end
      end

      def total_pages
        if data = pagination_data
          Integer(data.attr("totalPages"))
        else
          0
        end
      end

      def hotels
        body.css("ServiceHotel").lazy.map do |hotel|
          HotelBeds::Model::Hotel.new({
            id: hotel.at_css("HotelInfo Code").content,
            name: hotel.at_css("HotelInfo Name").content,
            images: hotel.css("HotelInfo ImageList Image Url").map(&:content),
            latitude: hotel.at_css("HotelInfo Position").attr("latitude"),
            longitude: hotel.at_css("HotelInfo Position").attr("longitude"),
            results: generate_results(hotel.css("AvailableRoom"))
          })
        end
      end

      private
      def pagination_data
        body.at_css("PaginationData")
      end

      def generate_results(rooms)
        parsed_rooms = parse_available_rooms(rooms)
        if request.group_results?
          RoomGrouper.new(request.rooms.map(&:attributes), parsed_rooms).results
        else
          parsed_rooms.map do |rooms|
            HotelBeds::Model::SearchResult.new(rooms: Array(rooms))
          end
        end
      end

      def parse_available_rooms(rooms)
        Array(rooms).map do |room|
          HotelBeds::Model::AvailableRoom.new({
            id: room.at_css("HotelRoom").attr("SHRUI"),
            adult_count: room.at_css("HotelOccupancy AdultCount").content,
            child_count: room.at_css("HotelOccupancy ChildCount").content,
            number_available: room.at_css("HotelRoom").attr("availCount"),
            description: room.at_css("HotelRoom RoomType").content,
            board: room.at_css("HotelRoom Board").content,
            currency: body.at_css("Currency").attr("code"),
            price: ((room.at_css("HotelRoom") > "Price") > "Amount").first.content,
            rates: parse_price_list(room.css("Price PriceList Price"))
          })
        end
      end

      def parse_price_list(prices)
        Array(prices).inject({}) do |result, price|
          from = Date.parse(price.at_css("DateTimeFrom").attr("date"))
          to = Date.parse(price.at_css("DateTimeTo").attr("date"))
          dates = (from..to).to_a
          amount = BigDecimal.new(price.at_css("Amount").content, 3)
          dates.each do |date|
            result.merge!(date => amount)
          end
          result
        end
      end
    end
  end
end
