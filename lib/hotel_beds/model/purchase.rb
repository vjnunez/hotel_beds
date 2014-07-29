require "hotel_beds/model"
require "hotel_beds/model/service"

module HotelBeds
  module Model
    class Purchase
      include HotelBeds::Model

      # attributes
      attribute :id, String
      attribute :services, Array[Service]
      attribute :currency, String
      attribute :amount, BigDecimal
    end
  end
end
