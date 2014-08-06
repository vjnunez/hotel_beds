require "hotel_beds/model"

module HotelBeds
  module BasketRemove
    class Request
      include HotelBeds::Model

      # attributes
      attribute :language, String, default: "ENG"
      attribute :purchase_token, String
      attribute :service_id, String


      # validation
      validates :language, length: { is: 3 }
      validates :service_id, :purchase_token, presence: true
    end
  end
end
