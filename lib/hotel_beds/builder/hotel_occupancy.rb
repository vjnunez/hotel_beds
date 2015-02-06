require "hotel_beds/core_ext/array"

using HotelBeds::CoreExt::Array

module HotelBeds
  module Builder
    class HotelOccupancy
      attr_accessor :rooms
      private :rooms=

      def initialize(rooms)
        self.rooms = rooms

        unless rooms.size > 0
          raise ArgumentError, "At least 1 room must be specified"
        end

        unless rooms.map(&:adult_count).uniq.size < 2
          raise ArgumentError, "All room adult_count values must match"
        end

        unless rooms.map(&:child_count).uniq.size < 2
          raise ArgumentError, "All room child_count values must match"
        end

        freeze
      end

      def child_ages
        rooms.map(&:child_ages).flatten_children
      end

      def adult_count
        rooms.first.adult_count
      end

      def child_count
        rooms.first.child_count
      end

      def to_h
        {
          RoomCount: rooms.size,
          Occupancy: {
            AdultCount: adult_count,
            ChildCount: child_count,
            GuestList: {
              Customer: 1.upto(adult_count).map {
                { :@type => "AD" }
              } + 1.upto(child_count).map { |i|
                { :@type => "CH", :Age => Integer(child_ages.fetch(i - 1)) }
              }
            }
          }
        }
      end
    end
  end
end
