require "hotel_beds/action/request"

module HotelBeds
  module BasketRemove
    class Request < HotelBeds::Action::Request
      # attributes
      attribute :purchase_token, String
      attribute :service_id, String

      # validation
      validates :service_id, :purchase_token, presence: true
    end
  end
end
