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
        end
        freeze
      end
      
      def inspect
        "<#{self.class.name} headers=#{headers.inspect} body=#{body.to_s}>"
      end
      
      def current_page
        Integer(body.css("PaginationData").first.attr("currentPage"))
      end
      
      def total_pages
        Integer(body.css("PaginationData").first.attr("totalPages"))
      end
      
      def hotels
        body.css("ServiceHotel").lazy.map do |hotel|
          HotelBeds::Model::Hotel.new({
            id: hotel.css("HotelInfo Code").first.content,
            name: hotel.css("HotelInfo Name").first.content,
            images: hotel.css("HotelInfo ImageList Image Url").map(&:content),
            latitude: hotel.css("HotelInfo Position").first.attr("latitude"),
            longitude: hotel.css("HotelInfo Position").first.attr("longitude"),
            results: parse_available_rooms(hotel.css("AvailableRoom"))
          })
        end
      end
      
      private
      
      def parse_available_rooms(rooms)
        Array(rooms).map do |room|
          {
            adult_count: room.css("HotelOccupancy AdultCount").first.content,
            child_count: room.css("HotelOccupancy ChildCount").first.content,
            rooms: parse_hotel_rooms(room.css("HotelRoom"))
          }
        end
      end

      def parse_hotel_rooms(rooms)
        Array(rooms).map do |room|
          {
            number_available: room.attr("availCount"),
            id: room.attr("SHRUI"),
            description: room.css("RoomType").first.content,
            board: room.css("Board").first.content,
            price: room.css("Price Amount").first.content,
            currency: body.css("Currency").first.attribute("code").value,
            rates: parse_price_list(room.css("PriceList Price"))
          }
        end
      end

      def parse_price_list(prices)
        Array(prices).inject({}) do |result, price|
          from = Date.parse(price.css("DateTimeFrom").first.attr("date"))
          to = Date.parse(price.css("DateTimeTo").first.attr("date"))
          dates = (from..to).to_a
          amount = BigDecimal.new(price.css("Amount").first.content) / dates.size
          dates.each do |date|
            result.merge!(date => amount)
          end
          result
        end
      end
    end
  end
end
