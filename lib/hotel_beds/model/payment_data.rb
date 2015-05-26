require "hotel_beds/model"

module HotelBeds
  module Model
    class PaymentData
      include HotelBeds::Model

      # attributes
      attribute :description, String
    end
  end
end
