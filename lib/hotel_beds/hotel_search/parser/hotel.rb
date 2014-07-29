require "ostruct"
require "hotel_beds/model/hotel"
require "hotel_beds/hotel_search/parser/room"
require "hotel_beds/hotel_search/parser/room_grouper"

module HotelBeds
  module HotelSearch
    module Parser
      class Hotel
        def self.call(*args, &block)
          new(*args, &block).call
        end

        attr_accessor :hotel, :currency, :request
        private :hotel=, :currency=, :request=

        def initialize(hotel:, currency:, request:)
          self.hotel = hotel
          self.currency = currency
          self.request = request
          freeze
        end

        def call
          HotelBeds::Model::Hotel.new({
            availability_token: hotel.attr("availToken"),
            id: hotel.at_css("HotelInfo Code").content,
            name: hotel.at_css("HotelInfo Name").content,
            images: hotel.css("HotelInfo ImageList Image Url").map(&:content),
            latitude: hotel.at_css("HotelInfo Position").attr("latitude"),
            longitude: hotel.at_css("HotelInfo Position").attr("longitude"),
            results: results,
            destination_code: hotel.at_css("HotelInfo Destination").attr("code"),
            contract_name: hotel.at_css("ContractList Contract Name").content,
            contract_incoming_office_code: hotel.at_css("ContractList Contract IncomingOffice").attr("code")
          })
        end

        private
        def rooms
          hotel.css("AvailableRoom")
        end

        def results
          group_rooms(parsed_available_rooms).map do |rooms|
            { rooms: Array(rooms), currency: currency }
          end
        end

        def group_rooms(rooms)
          if request.group_results?
            grouper = HotelBeds::HotelSearch::Parser::RoomGrouper
            grouper.new(request.rooms, rooms).results
          else
            rooms
          end
        end

        def parsed_available_rooms
          Array(rooms).map do |room|
            HotelBeds::HotelSearch::Parser::Room.call(room)
          end
        end
      end
    end
  end
end
