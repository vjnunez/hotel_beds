require "delegate"

module HotelBeds
  module Action
    class Envelope < SimpleDelegator
      def attributes
        raise NotImplementedError
      end
    end
  end
end
