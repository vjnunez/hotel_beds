require "hotel_beds/model/search_result"

# see INTERNALS.md for comment symbols
module HotelBeds
  module HotelSearch
    class RoomGrouper < Struct.new(:requested_rooms, :response_rooms)
      def results
        if requested_rooms.size == 1
          response_rooms.map { |room| [room] }
        else
          unique_room_combinations
        end
      end

      private
      def unique_room_combinations
        unique_combinations(expand_combinations(available_room_combinations))
      end

      def unique_combinations(combinations)
        combinations.uniq { |r| r.sort_by(&:id).map(&:id) }
      end

      def expand_combinations(combinations)
        combinations.map do |rooms|
          rooms.inject(Array.new) do |result, room|
            1.upto(room.room_count) do
              result << room.dup.tap { |r| r.room_count = 1 }
            end
            result
          end
        end
      end

      # returns an array of room combinations for all rooms
      def available_room_combinations
        head, *rest = room_options_grouped_by_occupants
        Array(head).product(*rest)
      end

      # returns a array of arrays, each contains available rooms for a given
      # room occupancy
      def room_options_grouped_by_occupants
        requested_room_count_by_occupants.inject(Array.new) do |result, (key, count)|
          result << response_rooms_by_occupants.fetch(key).select do |room|
            room.room_count == count
          end
        end
      rescue KeyError => e
        Array.new
      end

      # returns a hash of OK => 1 (count)
      def requested_room_count_by_occupants
        requested_rooms.inject(Hash.new) do |result, room|
          key = occupant_key(room)
          result[key] ||= 0
          result[key] += 1
          result
        end
      end

      # returns a hash of OK => [AvailableRoom, AvailableRoom, AvailableRoom]
      def response_rooms_by_occupants
        response_rooms.inject(Hash.new) do |result, room|
          key = occupant_key(room)
          result[key] ||= Array.new
          result[key].push(room)
          result
        end
      end

      # returns an OK for a given room
      def occupant_key(room)
        {
          adult_count: room.adult_count,
          child_count: room.child_count
        }
      end
    end
  end
end
