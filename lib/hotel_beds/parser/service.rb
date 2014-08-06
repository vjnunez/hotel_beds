require "hotel_beds/parser"
require "hotel_beds/parser/contract"

module HotelBeds
  module Parser
    class Service
      include HotelBeds::Parser

      # attributes
      attribute :id, attr: "SPUI"
      attribute :type, attr: "xsi:type"
      attribute :status, selector: "Status"
      attribute :date_from, selector: "DateFrom", attr: "date"
      attribute :date_to, selector: "DateTo", attr: "date"
      attribute :currency, selector: "Currency", attr: "code"
      attribute :amount, selector: "TotalAmount"
      attribute :contract, selector: "Contract",
        parser: HotelBeds::Parser::Contract
    end
  end
end
