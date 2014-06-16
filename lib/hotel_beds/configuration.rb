module HotelBeds
  class Configuration
    def self.endpoints
      {
        test: "http://testapi.interface-xml.com/appservices/ws/FrontendService".freeze,
        live: "http://api.interface-xml.com/appservices/ws/FrontendService".freeze,
      }
    end
    
    attr_accessor :endpoint, :username, :password, :proxy, :request_timeout,
      :response_timeout

    def initialize(endpoint: :test, username:, password:, proxy: nil, request_timeout: 5, response_timeout: 30)
      self.endpoint = self.class.endpoints.fetch(endpoint, endpoint)
      self.username = username
      self.password = password
      self.proxy = proxy
      self.request_timeout = Integer(request_timeout)
      self.response_timeout = Integer(response_timeout)
      freeze
    end
    
    def proxy?
      !!(proxy && !proxy.empty?)
    end
  end
end
