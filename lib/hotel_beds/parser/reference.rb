require "hotel_beds/parser"

module HotelBeds
  module Parser
    class Reference
      include HotelBeds::Parser

      # attributes
      attribute :file_number, selector: "FileNumber"
      attribute :incoming_office_code, {
        selector: "IncomingOffice",
        attr: "code"
      }
    end
  end
end
