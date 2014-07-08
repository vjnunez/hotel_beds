require "hotel_beds/response/base"
require "hotel_beds/model/hotel"
require "hotel_beds/model/available_room"
require "hotel_beds/model/hotel_room"

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
            results: hotel.css("AvailableRoom").map { |result|
              HotelBeds::Model::AvailableRoom.new({
                rooms: result.css("HotelRoom").map { |room|
                  HotelBeds::Model::HotelRoom.new({
                    id: room.attribute("SHRUI").value,
                    description: room.css("RoomType").first.content,
                    board: room.css("Board").first.content,
                    price: room.css("Price Amount").first.content
                  })
                }
              })
            }
          })
        end
      end
    end
  end
end
