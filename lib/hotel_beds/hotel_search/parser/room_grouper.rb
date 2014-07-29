# see INTERNALS.md for comment symbols
module HotelBeds
  module HotelSearch
    module Parser
      class RoomGrouper < Struct.new(:requested_rooms, :response_rooms)
        def results
          unique_room_combinations
        end

        private
        def unique_room_combinations
          combinations = build_combinations(room_options_grouped_by_occupants)
          unique_combinations(expand_combinations(combinations))
        end

        def unique_combinations(combinations)
          combinations.uniq { |r| r.sort_by(&:id).map(&:id) }
        end

        def expand_combinations(combinations)
          combinations.map do |rooms|
            rooms.inject(Array.new) do |result, room|
              # get an array of all the child ages
              child_ages = requested_rooms_child_ages_by_occupants.fetch(occupant_key(room))
              1.upto(room.room_count) do |i|
                result << room.dup.tap do |r|
                  r.room_count = 1
                  r.child_ages = child_ages.pop
                end
              end
              result
            end
          end
        end

        # returns an array of room combinations for all rooms
        def build_combinations(combinations)
          head, *rest = combinations
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

        # returns a hash of OK => [Integer]
        def requested_rooms_child_ages_by_occupants
          requested_rooms.inject(Hash.new) do |result, room|
            key = occupant_key(room)
            result[key] ||= Array.new
            result[key] += room.child_ages
            result
          end
        end

        # returns a hash of OK => [RR]
        def requested_rooms_by_occupants
          requested_rooms.inject(Hash.new) do |result, room|
            key = occupant_key(room)
            result[key] ||= Array.new
            result[key] << room
            result
          end
        end

        # returns a hash of OK => 1 (count)
        def requested_room_count_by_occupants
          requested_rooms_by_occupants.inject(Hash.new) do |result, (key, rooms)|
            result.merge(key => rooms.size)
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
end
