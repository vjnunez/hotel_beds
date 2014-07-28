require "delegate"

module HotelBeds
  module HotelSearch
    class Envelope < SimpleDelegator
      def attributes
        {
          Language: language,
          Service: {
            :"@availToken" => availability_token,
            :ContractList => { Contact: {
              Name: contract_name,
              IncomingOffice: { :"@code" => contract_incoming_office_code }
            } },
            :DateFrom => check_in_date,
            :DateTo => check_out_date,
            :HotelInfo => {
              Code: hotel,
              Destination: { :"@code" => destination }
            },
            :AvailableRoom => occupancy_list.merge({
              HotelRoom: {
                Board: { :"@code" => board_code },
                RoomType: { :"@characteristic" => room_type_characteristic },
              }
            })
          }
        }
      end

      private
      def occupancy_list
        { HotelOccupancy: Array(rooms).map { |room|
          guest_list = if room.child_count > 0
            { GuestList: { Customer: Array(room.child_ages).map { |age|
              { :@type => "CH", :Age => Integer(age) }
            } } }
          end
          {
            RoomCount: 1,
            Occupancy: (guest_list || Hash.new).merge({
              AdultCount: Integer(room.adult_count),
              ChildCount: Integer(room.child_count)
            })
          }
        } }
      end
    end
  end
end
