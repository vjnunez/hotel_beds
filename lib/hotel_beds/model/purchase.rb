require "hotel_beds/model"
require "hotel_beds/model/service"

module HotelBeds
  module Model
    class Purchase
      include HotelBeds::Model

      # attributes
      attribute :token, String
      attribute :time_to_expiration, Integer
      attribute :agency_reference, String
      attribute :status, String
      attribute :currency, String
      attribute :amount, BigDecimal
      attribute :services, Array[HotelBeds::Model::Service]
    end
  end
end
