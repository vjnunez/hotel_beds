require "hotel_beds/parser/errors"
require "hotel_beds/parser/purchase"

module HotelBeds
  module HotelBasketAdd
    class Response
      attr_accessor :request, :headers, :body, :errors
      private :request=, :headers=, :body=, :errors=

      def initialize(request, response)
        self.request = request
        self.headers = response.header
        self.body = Nokogiri::XML(response.body.fetch(:service_add))
        self.errors = HotelBeds::Parser::Errors.new(response).to_model(self)
        freeze
      end

      def inspect
        "<#{self.class.name} errors=#{errors.inspect} headers=#{headers.inspect} body=#{body.to_s}>"
      end

      def session_id
        request.session_id
      end

      def success?
        errors.empty?
      end

      def purchase
        HotelBeds::Parser::Purchase.new(body.at_css("Purchase")).to_model
      end
    end
  end
end
