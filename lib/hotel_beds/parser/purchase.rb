require "hotel_beds/parser"
require "hotel_beds/parser/service"
require "hotel_beds/parser/customer"

module HotelBeds
  module Parser
    class Purchase
      include HotelBeds::Parser

      # attributes
      attribute :token, attr: "purchaseToken"
      attribute :time_to_expiration, attr: "timeToExpiration"
      attribute :agency_reference, selector: "AgencyReference"
      attribute :status, selector: "Status"
      attribute :currency, selector: "Currency", attr: "code"
      attribute :amount, selector: "TotalPrice"
      attribute :services,
        selector: "ServiceList > Service", multiple: true,
        parser: HotelBeds::Parser::Service
      attribute :holder, selector: "Holder",
        parser: HotelBeds::Parser::Customer
    end
  end
end
