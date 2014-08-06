require "hotel_beds/model"
require "hotel_beds/model/contract"

module HotelBeds
  module Model
    class Service
      include HotelBeds::Model

      # attributes
      attribute :id, String
      attribute :type, String
      attribute :status, String
      attribute :contract, HotelBeds::Model::Contract
      attribute :date_from, Date
      attribute :date_to, Date
      attribute :currency, String
      attribute :amount, BigDecimal
    end
  end
end
