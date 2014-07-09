require "delegate"

module HotelBeds
  module HotelSearch
    class Envelope < SimpleDelegator
      def attributes
        {
          PaginationData: pagination_data,
          Language: language,
          CheckInDate: check_in_date,
          CheckOutDate: check_out_date,
          OccupancyList: occupancy_list
        }.merge(Hash(destination)).merge(Hash(hotels))
      end
      
      private
      def pagination_data
        { :@pageNumber => Integer(page_number) }
      end

      def language
        String(__getobj__.language).upcase
      end

      def check_in_date
        { :@date => __getobj__.check_in_date.strftime("%Y%m%d") }
      end

      def check_out_date
        { :@date => __getobj__.check_out_date.strftime("%Y%m%d") }
      end

      def destination
        if __getobj__.destination
          { Destination: {
            :@code => String(__getobj__.destination).upcase,
            :@type => "SIMPLE"
          } }
        end
      end
      
      def hotels
        if Array(__getobj__.hotels).any?
          { HotelCodeList: {
            :@withinResults => "Y",
            :ProductCode => Array(__getobj__.hotels)
          } }
        end
      end
      
      def occupancy_list
        Array(rooms).map do |room|
          { HotelOccupancy: {
            RoomCount: Integer(room.adult_count) + Integer(room.child_count),
            Occupancy: {
              AdultCount: Integer(room.adult_count),
              ChildCount: Integer(room.child_count)
            },
            GuestList: Array(room.child_ages).each { |age|
              { Customer: { :@type => "CH", :Age => Integer(age) } }
            }
          } }
        end
      end
    end
  end
end
