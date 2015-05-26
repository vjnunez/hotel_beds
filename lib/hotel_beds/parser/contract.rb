require "hotel_beds/parser"
require "hotel_beds/parser/comment"

module HotelBeds
  module Parser
    class Contract
      include HotelBeds::Parser

      # attributes
      attribute :name, selector: "Name"
      attribute :incoming_office_code, selector: "IncomingOffice", attr: "code"
      attribute :comments,
        selector: "CommentList Comment", multiple: true,
        parser: HotelBeds::Parser::Comment
    end
  end
end
