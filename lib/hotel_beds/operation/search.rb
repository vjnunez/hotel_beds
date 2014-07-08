require "hotel_beds/operation/base"
require "hotel_beds/response/search"

module HotelBeds
  module Operation
    class Search < Base
      def method
        :getHotelValuedAvail
      end
      
      def namespace
        :HotelValuedAvailRQ
      end
      
      def message
        { namespace => {
          PaginationData: pagination_data,
          Language: language,
          CheckInDate: check_in_date,
          CheckOutDate: check_out_date,
          Destination: destination,
          OccupancyList: occupancy_list
        } }
      end
      
      def parse_response(response)
        HotelBeds::Response::Search.new(response)
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
        { :@code => String(__getobj__.destination).upcase, :@type => "SIMPLE" }
      end
      
      def occupancy_list
        Array(rooms).map do |room|
          { HotelOccupancy: {
            RoomCount: Integer(room.adult_count) + Integer(room.child_count),
            Occupancy: {
              AdultCount: Integer(room.adult_count),
              ChildCount: Integer(room.child_count)
            },
            GuestList: room.child_ages.each { |age|
              { Customer: { :@type => "CH", :Age => Integer(age) } }
            }
          } }
        end
      end
    end
  end
end
