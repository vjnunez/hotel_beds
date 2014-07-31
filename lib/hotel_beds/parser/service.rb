require "hotel_beds/parser"

module HotelBeds
  module Parser
    class Service
      include HotelBeds::Parser

      # attributes
      attribute :id, attr: "SPUI"
      attribute :contract_name, selector: "Contract Name"
      attribute :contract_incoming_office_code, selector: "Contract IncomingOffice", attr: "code"
      attribute :check_in_date, selector: "DateFrom", attr: "date"
      attribute :check_out_date, selector: "DateTo", attr: "date"
      attribute :currency, selector: "Currency", attr: "code"
      attribute :amount, selector: "TotalAmount"
    end
  end
end
