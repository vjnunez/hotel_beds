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
        }.merge(Hash(destination)).merge(Hash(hotels)).merge(Hash(extra_params))
      end

      private
      def extra_params
        { ExtraParamList: {
          ExtendedData: [{
            :@type => "EXT_ADDITIONAL_PARAM",
            :Name => "PARAM_KEY_PRICE_BREAKDOWN",
            :Value => "Y"
          }, {
            :@type => "EXT_ORDER",
            :Name => "ORDER_CONTRACT_PRICE",
            :Value => "ASC"
          }]
        } }
      end

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
        { HotelOccupancy: Array(rooms).group_by(&:group_key).map { |key,rooms|
          # if any room has children, add the ages
          guest_list = if rooms.any? { |room| room.child_count > 0 }
            { GuestList: {
              Customer: Array(rooms.map(&:child_ages).flatten).map { |age|
                { :@type => "CH", :Age => Integer(age) }
              }
            } }
          end
          # build the room(s) specification
          {
            RoomCount: rooms.size,
            Occupancy: (guest_list || Hash.new).merge({
              AdultCount: Integer(rooms.map(&:adult_count).inject(0, :+)),
              ChildCount: Integer(rooms.map(&:child_count).inject(0, :+))
            })
          }
        } }
      end
    end
  end
end
