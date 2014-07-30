require "hotel_beds/hotel_search/parser/price"
require "hotel_beds/model/available_room"

module HotelBeds
  module HotelSearch
    module Parser
      class Room
        def self.call(*args, &block)
          new(*args, &block).call
        end

        attr_accessor :room, :check_in_date, :check_out_date
        private :room=, :check_in_date=, :check_out_date=

        def initialize(room, check_in_date:, check_out_date:)
          self.room = room
          self.check_in_date = check_in_date
          self.check_out_date = check_out_date
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
            board_code: room.at_css("HotelRoom Board").attr("code"),
            room_type_code: room.at_css("HotelRoom RoomType").attr("code"),
            room_type_characteristic: room.at_css("HotelRoom RoomType").attr("characteristic"),
            price: total_price,
            rates: parse_price_list(room.css("Price PriceList Price"))
          })
        end

        private
        def total_price
          raw = ((room.at_css("HotelRoom") > "Price") > "Amount").first.content
          BigDecimal.new(raw.to_s)
        end

        def parse_price_list(prices)
          if prices.empty?
            dates = (check_in_date..check_out_date).to_a
            amount = total_price / dates.size
            dates.inject(Hash.new) do |result, date|
              result.merge(date => amount)
            end
          else
            Array(prices).map do |price|
              HotelBeds::HotelSearch::Parser::Price.call(price)
            end.inject(Hash.new, :merge)
          end
        end
      end
    end
  end
end
