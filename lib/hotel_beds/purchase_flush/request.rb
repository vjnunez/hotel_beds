require "hotel_beds/model"

module HotelBeds
  module BasketRemove
    class Request
      include HotelBeds::Model

      # attributes
      attribute :language, String, default: "ENG"
      attribute :purchase_token, String

      # validation
      validates :language, length: { is: 3 }
      validates :purchase_token, presence: true
    end
  end
end
