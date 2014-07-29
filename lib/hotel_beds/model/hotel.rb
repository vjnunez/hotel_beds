require "hotel_beds/model"
require_relative "search_result"

module HotelBeds
  module Model
    class Hotel
      include HotelBeds::Model

      # attributes
      attribute :id, Integer
      attribute :availability_token, String
      attribute :name, String
      attribute :images, Array[String]
      attribute :stars, Integer
      attribute :longitude, BigDecimal
      attribute :latitude, BigDecimal
      attribute :results, Array[SearchResult]
      attribute :destination_code, String
      attribute :contract_name, String
      attribute :contract_incoming_office_code, String
    end
  end
end
