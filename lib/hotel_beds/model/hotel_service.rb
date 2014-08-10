require "hotel_beds/model/hotel"
require "hotel_beds/model/contract"

module HotelBeds
  module Model
    class HotelService < Hotel
      # attributes
      attribute :id, String
      attribute :type, String
      attribute :status, String
      attribute :date_from, Date
      attribute :date_to, Date
      attribute :currency, String
      attribute :amount, BigDecimal
    end
  end
end
