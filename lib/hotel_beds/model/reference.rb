require "hotel_beds/model"

module HotelBeds
  module Model
    class Reference
      include HotelBeds::Model

      # attributes
      attribute :file_number, String
      attribute :incoming_office_code, String
    end
  end
end
