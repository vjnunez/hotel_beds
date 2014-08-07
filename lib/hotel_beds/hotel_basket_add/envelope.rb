require "delegate"
require "hotel_beds/builder/hotel_occupancy"

module HotelBeds
  module HotelBasketAdd
    class Envelope < SimpleDelegator
      def attributes
        {
          Language: language,
          Service: {
            :"@xsi:type" => "ServiceHotel",
            :"@availToken" => service.availability_token,
            :ContractList => { Contract: {
              Name: service.contract_name,
              IncomingOffice: { :@code => service.contract_incoming_office_code }
            } },
            :DateFrom => { :@date => service.check_in_date.strftime("%Y%m%d") },
            :DateTo => { :@date => service.check_out_date.strftime("%Y%m%d") },
            :HotelInfo => {
              Code: service.hotel_code,
              Destination: {
                :@code => service.destination_code,
                :@type => "SIMPLE"
              }
            },
            :AvailableRoom => available_rooms
          }
        }
      end

      private
      def available_rooms
        Array(service.rooms).group_by(&:group_key).values.map do |rooms|
          {
            HotelOccupancy: build_room(rooms),
            HotelRoom: {
              Board: {
                :@code => rooms.first.board_code,
                :@type => "SIMPLE"
              },
              RoomType: {
                :@code => rooms.first.room_type_code,
                :@characteristic => rooms.first.room_type_characteristic,
                :@type => "SIMPLE"
              },
            }
          }
        end
      end

      def build_room(rooms)
        HotelBeds::Builder::HotelOccupancy.new(rooms).to_h
      end
    end
  end
end
