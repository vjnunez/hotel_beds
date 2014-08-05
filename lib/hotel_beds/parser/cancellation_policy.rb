require "hotel_beds/parser"

module HotelBeds
  module Parser
    class CancellationPolicy
      include HotelBeds::Parser

      # attributes
      attribute :amount, attr: "amount"
      attribute :from, attr: "dateFrom"
    end
  end
end
