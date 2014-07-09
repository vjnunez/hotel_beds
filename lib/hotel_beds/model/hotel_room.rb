require "hotel_beds/model"

module HotelBeds
  module Model
    class HotelRoom
      include HotelBeds::Model

      # attributes
      attribute :id, Integer
      attribute :description, String
      attribute :board, String
      attribute :price, BigDecimal
      attribute :currency, String
    end
  end
end
