require "delegate"

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
        child_ages = rooms.map(&:child_ages).inject(Array.new, :+)
        adult_count = rooms.map(&:adult_count).inject(0, :+)
        child_count = rooms.map(&:child_count).inject(0, :+)
        {
          RoomCount: rooms.size,
          Occupancy: {
            AdultCount: adult_count,
            ChildCount: child_count,
            GuestList: {
              Customer: (1..adult_count).map {
                { :@type => "AD" }
              } + (1..child_count).map { |i|
                { :@type => "CH", :Age => Integer(child_ages[i - 1]) }
              }
            }
          }
        }
      end
    end
  end
end
