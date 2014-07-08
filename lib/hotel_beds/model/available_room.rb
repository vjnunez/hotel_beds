require "hotel_beds/model/hotel_room"
require "virtus"

module HotelBeds
  module Model
    class AvailableRoom
      # attributes
      include Virtus.model
      attribute :rooms, Array[HotelRoom]
    end
  end
end
