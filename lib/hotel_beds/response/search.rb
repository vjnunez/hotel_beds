require "hotel_beds/response/base"
require "hotel_beds/model/hotel"

module HotelBeds
  module Response
    class Search < Base
      def hotels
        body.css("ServiceHotel").lazy.map do |hotel|
          HotelBeds::Model::Hotel.new({
            id: hotel.css("HotelInfo Code").first.content,
            name: hotel.css("HotelInfo Name").first.content,
            images: hotel.css("HotelInfo ImageList Image Url").map(&:content),
            latitude: hotel.css("HotelInfo Position").attr("latitude"),
            longitude: hotel.css("HotelInfo Position").attr("longitude"),
          })
        end
      end
    end
  end
end
