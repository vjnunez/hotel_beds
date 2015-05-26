require "securerandom"
require "hotel_beds/action/request"
require "hotel_beds/model"
require "hotel_beds/model/customer"

module HotelBeds
  module PurchaseCancel
    class Request < HotelBeds::Action::Request
      class PurchaseReference
        include HotelBeds::Model

        # attributes
        attribute :file_number, String
        attribute :incoming_office, String

        # validation
        validates :file_number, :incoming_office, presence: true
      end

      # attributes
      attribute :purchase_reference, PurchaseReference
      attribute :view_or_cancel, String

      # validation
      validates :purchase_reference, presence: true
      validate do |request|
        if request.purchase_reference && request.purchase_reference.invalid?
          request.purchase_reference.errors.full_messages.each do |message|
            request.errors.add(:purchase_reference, message)
          end
        end
      end
    end
  end
end
