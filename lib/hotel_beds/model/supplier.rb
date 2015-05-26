require "hotel_beds/model"

module HotelBeds
  module Model
    class Supplier
      include HotelBeds::Model

      # attributes
      attribute :name, String
      attribute :vat_number, String
    end
  end
end
