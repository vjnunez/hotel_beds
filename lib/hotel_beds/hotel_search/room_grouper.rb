require "hotel_beds/model/search_result"

# see INTERNALS.md for comment symbols
module HotelBeds
  module HotelSearch
    class RoomGrouper < Struct.new(:requested_rooms, :response_rooms)
      def results
        @results ||= grouped_rooms.map do |rooms|
          HotelBeds::Model::SearchResult.new(rooms: Array(rooms))
        end
      end

      private
      def grouped_rooms
        if requested_rooms.size == 1
          response_rooms
        else
          combined_available_rooms
        end
      end

      # returns an array of room combinations for all rooms
      def combined_available_rooms
        head, *rest = combine_available_rooms_by_occupants.values
        head.product(*rest)
      end

      # returns a hash of OK => RSRG
      def combine_available_rooms_by_occupants
        group_requested_room_count_by_occupants.to_a.inject(Hash.new) do |result, (key, count)|
          result[key] = group_rooms_by_occupants.fetch(key).combination(count).to_a
        end
      rescue KeyError => e
        Array.new
      end

      # returns a hash of OK => RC
      def group_requested_room_count_by_occupants
        requested_rooms.inject(Hash.new) do |result, room|
          key = occupant_key(room)
          result[key] ||= 0
          result[key] += 1
          result
        end
      end

      # returns a hash of OK => AR
      def group_rooms_by_occupants
        @frozen_rooms ||= response_rooms.inject(Hash.new) do |result, room|
          key = occupant_key(room)
          result[key] ||= Array.new
          1.upto([room.number_available, 5].min) do |i|
            result[key].push(room)
          end
          result
        end.freeze
      end

      # returns an OK for a given room
      def occupant_key(room)
        {
          adult_count: room.fetch(:adult_count),
          child_count: room.fetch(:child_count)
        }
      end
    end
  end
end
