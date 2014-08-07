require "hotel_beds/action/envelope"

module HotelBeds
  module PurchaseFlush
    class Envelope < HotelBeds::Action::Envelope
      def attributes
        {
          :Language => language,
          :@version => "2013/12",
          :@purchaseToken => purchase_token
        }
      end
    end
  end
end
