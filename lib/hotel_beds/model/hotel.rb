require "hotel_beds/model/available_room"
require "virtus"

module HotelBeds
  module Model
    class Hotel
      # attributes
      include Virtus.model
      attribute :id, Integer
      attribute :name, String
      attribute :images, Array[String]
      attribute :stars, Integer
      attribute :longitude, BigDecimal
      attribute :latitude, BigDecimal
      attribute :results, Array[AvailableRoom]
    end
  end
end