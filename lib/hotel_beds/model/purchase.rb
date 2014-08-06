require "hotel_beds/model"
require "hotel_beds/model/service"
require "hotel_beds/model/customer"

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
      attribute :holder, HotelBeds::Model::Customer
    end
  end
end
