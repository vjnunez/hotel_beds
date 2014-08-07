require "delegate"

module HotelBeds
  module PurchaseFlush
    class Envelope < SimpleDelegator
      def attributes
        {
          :Language => language,
          :@version => "2013/12",
          :@purchaseToken => purchase.token
        }
      end
    end
  end
end
