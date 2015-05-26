require "hotel_beds/parser"

module HotelBeds
  module Parser
    class Price
      include HotelBeds::Parser

      # attributes
      attribute :from, selector: "DateTimeFrom", attr: "date"
      attribute :to, selector: "DateTimeTo", attr: "date"
      attribute :amount, selector: "Amount"
    end
  end
end
