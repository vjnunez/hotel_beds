require "hotel_beds/configuration"

module HotelBeds
  class Client
    attr_accessor :configuration

    def initialize(**config)
      self.configuration = Configuration.new(**config)
      freeze
    end
  end
end
