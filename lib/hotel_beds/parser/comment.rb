require "hotel_beds/parser"

module HotelBeds
  module Parser
    class Comment
      include HotelBeds::Parser

      # attributes
      attribute :type, attr: "type"
      attribute :content
    end
  end
end
