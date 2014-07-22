require "hotel_beds/model"
require_relative "available_room"

module HotelBeds
  module Model
    class SearchResult
      include HotelBeds::Model

      # attributes
      attribute :rooms, Array[AvailableRoom]
      attribute :currency, String

      # results are purely based upon their combination of rooms
      def <=>(other)
        rooms.map(&:id).sort == other.rooms.map(&:id).sort
      end

      # returns the total price of all the rooms collectively
      def price
        rooms.map(&:price).inject(BigDecimal.new("0.0"), :+)
      end
    end
  end
end
