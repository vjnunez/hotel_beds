require "hotel_beds/parser/hotel"

module HotelBeds
  module Parser
    class HotelService < Hotel
      # attributes
      attribute :id, attr: "SPUI"
      attribute :type, attr: "xsi:type"
      attribute :status, selector: "Status"
      attribute :date_from, selector: "DateFrom", attr: "date"
      attribute :date_to, selector: "DateTo", attr: "date"
      attribute :currency, selector: "Currency", attr: "code"
      attribute :amount, selector: "TotalAmount"
    end
  end
end
