require "hotel_beds/configuration"
require "hotel_beds/connection"

module HotelBeds
  class Client
    attr_accessor :configuration, :connection
    private :configuration=, :connection, :connection=

    def initialize(**config)
      self.configuration = Configuration.new(**config)
      self.connection = Connection.new(configuration)
      freeze
    end
    
    def perform(model)
      connection.perform(model.to_operation)
    end
  end
end
