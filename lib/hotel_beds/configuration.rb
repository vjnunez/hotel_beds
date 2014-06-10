module HotelBeds
  class Configuration
    def self.endpoints
      {
        test: "http://testapi.interface-xml.com/appservices/ws/FrontendService".freeze,
        live: "http://api.interface-xml.com/appservices/ws/FrontendService".freeze,
      }
    end
    
    attr_accessor :endpoint, :username, :password, :proxy

    def initialize(endpoint: :test, username:, password:, proxy: nil)
      self.endpoint = self.class.endpoints.fetch(endpoint, endpoint)
      self.username = username
      self.password = password
      self.proxy = proxy
      freeze
    end
  end
end
