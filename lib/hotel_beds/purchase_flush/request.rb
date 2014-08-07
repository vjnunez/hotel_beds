require "hotel_beds/action/request"

module HotelBeds
  module PurchaseFlush
    class Request < HotelBeds::Action::Request
      # attributes
      attribute :purchase_token, String

      # validation
      validates :purchase_token, presence: true
    end
  end
end
