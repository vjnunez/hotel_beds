require "hotel_beds/parser/errors"
require "hotel_beds/parser/hotel"

module HotelBeds
  module HotelSearch
    class Response
      attr_accessor :request, :headers, :body, :errors
      private :request=, :headers=, :body=, :errors=

      def initialize(request, response)
        self.request = request
        self.headers = response.header
        self.body = Nokogiri::XML(response.body.fetch(:get_hotel_valued_avail))
        self.errors = HotelBeds::Parser::Errors.new(response).to_model(self)
        freeze
      end

      def inspect
        "<#{self.class.name} errors=#{errors.inspect} headers=#{headers.inspect} body=#{body.to_s}>"
      end

      def session_id
        request.session_id
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
          HotelBeds::Parser::Hotel.new(hotel).to_model
        end
      end

      private
      def pagination_data
        body.at_css("PaginationData")
      end
    end
  end
end
