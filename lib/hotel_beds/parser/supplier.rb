require "hotel_beds/parser/hotel"

module HotelBeds
  module Parser
    class Supplier < Hotel
      # attributes
      attribute :name, attr: "name"
      attribute :vat_number, attr: "vatNumber"
    end
  end
end
