require "hotel_beds/parser/hotel"

module HotelBeds
  module Parser
    class Supplier
      include HotelBeds::Parser

      # attributes
      attribute :name, attr: "name"
      attribute :vat_number, attr: "vatNumber"
    end
  end
end
