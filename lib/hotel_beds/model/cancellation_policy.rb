require "hotel_beds/model"

module HotelBeds
  module Model
    class CancellationPolicy
      include HotelBeds::Model

      # attributes
      attribute :amount, BigDecimal
      attribute :from, Time
    end
  end
end
