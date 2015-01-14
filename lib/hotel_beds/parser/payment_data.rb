require "hotel_beds/parser"

module HotelBeds
  module Parser
    class PaymentData
      include HotelBeds::Parser

      # attributes
      attribute :description, selector: "Description"
    end
  end
end
