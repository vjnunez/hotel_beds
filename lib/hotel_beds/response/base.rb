require "forwardable"
require "nokogiri"

module HotelBeds
  module Response
    class Base
      # attributes
      attr_accessor :response, :body, :headers
      private :response, :response=, :body=, :headers=
      
      # delegation
      extend Forwardable
      def_delegators :response, :success?, :soap_fault?, :http_error?
      
      def initialize(response)
        self.response = response
        self.headers = response.header
        self.body = Nokogiri::XML(response.body.fetch(:get_hotel_valued_avail))
        freeze
      end
      
      def inspect
        "<#{self.class.name} headers=#{headers.inspect} body=#{body.inspect}>"
      end
    end
  end
end
