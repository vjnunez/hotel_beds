require "hotel_beds/model/hotel"
require "hotel_beds/hotel_search/parser/errors"
require "hotel_beds/hotel_search/parser/hotel"

module HotelBeds
  module HotelSearch
    class Response
      attr_accessor :request, :headers, :body, :errors
      private :request=, :headers=, :body=, :errors=

      def initialize(request, response)
        self.request = request
        self.headers = response.header
        self.body = Nokogiri::XML(response.body.fetch(:get_hotel_valued_avail))
        self.errors = HotelBeds::HotelSearch::Parser::Errors.call(response, body)
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

      def currency
        body.at_css("Currency").attr("code")
      end

      def hotels
        body.css("ServiceHotel").lazy.map do |hotel|
          HotelBeds::HotelSearch::Parser::Hotel.call(
            hotel: hotel,
            currency: currency,
            request: request
          )
        end
      end

      private
      def pagination_data
        body.at_css("PaginationData")
      end
    end
  end
end
