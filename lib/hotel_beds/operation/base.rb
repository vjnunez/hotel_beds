require "delegate"
require "securerandom"

module HotelBeds
  module Operation
    class Base < SimpleDelegator     
      def method
        raise NotImplementedError, "#method should return a symbol for the \
          remote method to be called"
      end
      
      def namespace
        raise NotImplementedError, "#namespace should return a symbol for the \
          root element within the <message> element"
      end
      
      def message
        raise NotImplementedError, "#message should return a hash containing \
          the contents of the <message> element, the #namespace should be \
          included as a key"
      end
      
      def parse_response(response)
        raise NotImplementedError, "#parse_response should accept a SOAP \ 
          response and return a HotelBeds::Response::Base subclass object"
      end
    end
  end
end
