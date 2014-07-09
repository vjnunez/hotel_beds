require "hotel_beds/configuration"
require "hotel_beds/connection"
require "hotel_beds/hotel_search/operation"

module HotelBeds
  class Client
    attr_accessor :configuration, :connection
    private :configuration=, :connection, :connection=

    def initialize(**config)
      self.configuration = Configuration.new(**config)
      self.connection = Connection.new(configuration)
      freeze
    end
    
    # builds and performs a hotel search, returning an operation object which
    # contains both the request and response objects.
    def perform_hotel_search(*args)
      HotelSearch::Operation.new(*args).perform(
        connection: connection
      )
    end
  end
end
