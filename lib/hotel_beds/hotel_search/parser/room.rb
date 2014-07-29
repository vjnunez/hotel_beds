require "hotel_beds/hotel_search/parser/price"
require "hotel_beds/model/available_room"

module HotelBeds
  module HotelSearch
    module Parser
      class Room
        def self.call(*args, &block)
          new(*args, &block).call
        end

        attr_accessor :room
        private :room=

        def initialize(room)
          self.room = room
          freeze
        end

        def call
          HotelBeds::Model::AvailableRoom.new({
            id: room.at_css("HotelRoom").attr("SHRUI"),
            room_count: room.at_css("HotelOccupancy RoomCount").content,
            adult_count: room.at_css("HotelOccupancy AdultCount").content,
            child_count: room.at_css("HotelOccupancy ChildCount").content,
            number_available: room.at_css("HotelRoom").attr("availCount"),
            description: room.at_css("HotelRoom RoomType").content,
            board: room.at_css("HotelRoom Board").content,
            price: ((room.at_css("HotelRoom") > "Price") > "Amount").first.content,
            rates: parse_price_list(room.css("Price PriceList Price"))
          })
        end

        private
        def parse_price_list(prices)
          Array(prices).map do |price|
            HotelBeds::HotelSearch::Parser::Price.call(price)
          end.inject(Hash.new, :merge)
        end
      end
    end
  end
end
