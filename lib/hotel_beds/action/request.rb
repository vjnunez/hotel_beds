require "hotel_beds/model"

module HotelBeds
  module Action
    class Request
      include HotelBeds::Model

      # attributes
      attribute :language, String, default: "ENG"

      # validation
      validates :language, length: { is: 3 }
    end
  end
end
