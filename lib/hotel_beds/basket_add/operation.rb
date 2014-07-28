require_relative "request"
require_relative "response"
require_relative "envelope"

module HotelBeds
  module BasketAdd
    class Operation
      attr_accessor :request, :response, :errors
      private :request=, :response=, :errors=

      def initialize(*args)
        self.request = Request.new(*args)
      end

      def perform(connection:)
        if request.valid?
          self.response = Response.new(request, retrieve(connection))
          self.errors = response.errors
        else
          self.errors = request.errors
        end
        freeze
        self
      end

      private
      def retrieve(connection)
        connection.call({
          method: :serviceAdd,
          namespace: :ServiceAddRQ,
          data: Envelope.new(request).attributes
        })
      end
    end
  end
end
