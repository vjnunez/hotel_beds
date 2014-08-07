require "hotel_beds/model"

module HotelBeds
  module PurchaseFlush
    class Request
      class Purchase
        include HotelBeds::Model

        # attributes
        attribute :token, String

        # validation
        validates :token, presence: true
      end

      include HotelBeds::Model

      # attributes
      attribute :language, String, default: "ENG"
      attribute :purchase, Purchase

      # validation
      validates :language, length: { is: 3 }
      validates :purchase, presence: true
      validate do |request|
        if purchase && purchase.invalid?
          purchase.errors.full_messages.each do |message|
            request.errors.add(:purchase, message)
          end
        end
      end
    end
  end
end
