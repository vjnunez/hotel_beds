require "hotel_beds/model"
require_relative "available_room"

module HotelBeds
  module Model
    class Hotel
      include HotelBeds::Model

      # attributes
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