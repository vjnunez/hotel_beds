require "hotel_beds/action/response"
require "hotel_beds/parser/hotel"

module HotelBeds
  module HotelSearch
    class Response < HotelBeds::Action::Response
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
