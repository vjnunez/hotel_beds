require "delegate"

module HotelBeds
  module BasketRemove
    class Envelope < SimpleDelegator
      def attributes
        {
          :Language => language,
          :@version => "2013/12",
          :@purchase_token => purchase_token
        }
      end
    end
  end
end
