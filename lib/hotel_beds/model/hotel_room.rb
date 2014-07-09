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
      attribute :number_available, Integer
    end
  end
end
