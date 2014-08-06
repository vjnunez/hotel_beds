require "hotel_beds/parser"

module HotelBeds
  module Parser
    class Customer
      include HotelBeds::Parser

      # attributes
      attribute :id, selector: "CustomerId"
      attribute :type do |element|
        element.attr("type") == "CH" ? :child : :adult
      end
      attribute :name, selector: "Name"
      attribute :last_name, selector: "LastName"
      attribute :age, selector: "Age"
    end
  end
end
