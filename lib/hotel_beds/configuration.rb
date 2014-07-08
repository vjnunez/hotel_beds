module HotelBeds
  class Configuration
    def self.endpoints
      path = "appservices/ws/FrontendService"
      {
        test: "http://testapi.interface-xml.com/#{path}".freeze,
        live: "http://api.interface-xml.com/#{path}".freeze,
      }
    end
    
    attr_accessor :endpoint, :username, :password, :proxy, :request_timeout,
      :response_timeout, :enable_logging

    def initialize(endpoint: :test, username:, password:, proxy: nil, request_timeout: 5, response_timeout: 30, enable_logging: false)
      self.endpoint = self.class.endpoints.fetch(endpoint, endpoint)
      self.username = username
      self.password = password
      self.proxy = proxy
      self.request_timeout = Integer(request_timeout)
      self.response_timeout = Integer(response_timeout)
      self.enable_logging = enable_logging
      freeze
    end
    
    def enable_logging?
      !!enable_logging
    end
    
    def proxy?
      !!(proxy && !proxy.empty?)
    end
  end
end
