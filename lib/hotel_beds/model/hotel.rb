require "hotel_beds/model"
require_relative "search_result"

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
      attribute :results, Array[SearchResult]
    end
  end
end
