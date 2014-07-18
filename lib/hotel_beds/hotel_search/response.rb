require "active_model/errors"
require "hotel_beds/model/hotel"

module HotelBeds
  module HotelSearch
    class Response
      attr_accessor :headers, :body, :errors
      private :headers=, :body=, :errors=
      
      def initialize(response)
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
              (m = error.at_css("Message") && m.content),
              (dm = error.at_css("DetailedMessage") && dm.content)
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
            results: parse_available_rooms(hotel.css("AvailableRoom"))
          })
        end
      end
      
      private
      def pagination_data
        body.at_css("PaginationData")
      end
          
      def parse_available_rooms(rooms)
        Array(rooms).map do |room|
          {
            adult_count: room.at_css("HotelOccupancy AdultCount").content,
            child_count: room.at_css("HotelOccupancy ChildCount").content,
            rooms: parse_hotel_rooms(room.css("HotelRoom"))
          }
        end
      end

      def parse_hotel_rooms(rooms)
        Array(rooms).map do |room|
          {
            number_available: room.attr("availCount"),
            id: room.attr("SHRUI"),
            description: room.at_css("RoomType").content,
            board: room.at_css("Board").content,
            price: ((room > "Price") > "Amount").first.content,
            currency: body.at_css("Currency").attr("code"),
            rates: parse_price_list(room.css("Price PriceList Price"))
          }
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
