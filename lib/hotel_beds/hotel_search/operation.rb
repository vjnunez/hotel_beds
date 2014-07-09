require_relative "request"
require_relative "response"
require_relative "envelope"

module HotelBeds
  module HotelSearch
    class Operation
      attr_accessor :request, :response, :errors
      private :request=, :response=, :errors=
      
      def initialize(*args)
        self.request = Request.new(*args)
      end
      
      def perform(connection:)
        if request.valid?
          self.response = Response.new(retrieve(connection))
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
          method: :getHotelValuedAvail, 
          namespace: :HotelValuedAvailRQ,
          data: Envelope.new(request).attributes
        })
      end
    end
  end
end
