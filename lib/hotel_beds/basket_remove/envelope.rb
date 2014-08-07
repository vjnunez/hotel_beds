require "hotel_beds/action/envelope"

module HotelBeds
  module BasketRemove
    class Envelope < HotelBeds::Action::Envelope
      def attributes
        {
          :Language => language,
          :@SPUI => service_id,
          :@version => "2013/12",
          :@purchaseToken => purchase_token
        }
      end
    end
  end
end
