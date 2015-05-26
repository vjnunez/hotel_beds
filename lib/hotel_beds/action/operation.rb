module HotelBeds
  module Action
    class Operation
      def self.remote_method(value = nil)
        @remote_method = value if value
        @remote_method
      end

      def self.remote_namespace(value = nil)
        @remote_namespace = value if value
        @remote_namespace
      end

      def self.request_class(value = nil)
        @request_class = value if value
        @request_class
      end

      def self.response_class(value = nil)
        @response_class = value if value
        @response_class
      end

      def self.envelope_class(value = nil)
        @envelope_class = value if value
        @envelope_class
      end

      attr_accessor :request, :response, :errors, :action_module
      private :request=, :response=, :errors=, :action_module, :action_module=

      def initialize(*args)
        self.request = self.class.request_class.new(*args)
      end

      def perform(connection:)
        if request.valid?
          self.response = self.class.response_class.new(request, retrieve(connection))
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
          method: self.class.remote_method,
          namespace: self.class.remote_namespace,
          data: self.class.envelope_class.new(request).attributes
        })
      end
    end
  end
end
