require "hotel_beds/parser"

module HotelBeds
  module Parser
    class Destination
      include HotelBeds::Parser

      # attributes
      attribute :code, attr: "code"
      attribute :name, selector: "Name"
    end
  end
end
