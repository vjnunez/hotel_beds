require "hotel_beds/model"
require_relative "hotel_room"

module HotelBeds
  module Model
    class AvailableRoom
      include HotelBeds::Model
    
      # attributes
      attribute :rooms, Array[HotelRoom]
      attribute :adult_count, Integer
      attribute :child_count, Integer
    end
  end
end
