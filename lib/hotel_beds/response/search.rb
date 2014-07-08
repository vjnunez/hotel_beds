require "hotel_beds/response/base"
require "hotel_beds/model/hotel"

module HotelBeds
  module Response
    class Search < Base
      def current_page
        Integer(body.css("PaginationData").attr("currentPage").value)
      end
      
      def total_pages
        Integer(body.css("PaginationData").attr("totalPages").value)
      end
      
      def hotels
        body.css("ServiceHotel").lazy.map do |hotel|
          HotelBeds::Model::Hotel.new({
            id: hotel.css("HotelInfo Code").first.content,
            name: hotel.css("HotelInfo Name").first.content,
            images: hotel.css("HotelInfo ImageList Image Url").map(&:content),
            latitude: hotel.css("HotelInfo Position").attr("latitude").value,
            longitude: hotel.css("HotelInfo Position").attr("longitude").value,
          })
        end
      end
    end
  end
end
