require "savon"

module HotelBeds
  class Connection
    attr_accessor :client
    private :client, :client=

    def initialize(configuration)
      self.client = Savon::Client.new do |config|
        # http requests
        config.endpoint(configuration.endpoint)
        config.proxy(configuration.proxy) if configuration.proxy?
        config.headers "Accept-Encoding" => "gzip, deflate"

        # soap specifics
        config.env_namespace :soapenv
        config.namespace "http://schemas.xmlsoap.org/soap/envelope/"
        config.namespaces "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
          "soapenv:encodingStyle" => "http://schemas.xmlsoap.org/soap/encoding/"
        config.namespace_identifier :hb
        config.convert_request_keys_to :none
  
        # request timeout
        config.open_timeout(configuration.request_timeout)
        config.read_timeout(configuration.response_timeout)
  
        # request building
        config.encoding "UTF-8"
  
        # logging
        config.log true
        config.log_level :debug
        config.pretty_print_xml true
        config.filters [:password]
      end
    end

    def perform(operation)
      client.call(operation.method, {
        :soap_action => "",
        :attributes => {
          :"xmlns:hb" => "http://axis.frontend.hydra.hotelbeds.com",
          :"xsi:type" => "xsd:string",
        },
        :message => { operation.namespace => {
          :@xmlns => "http://www.hotelbeds.com/schemas/2005/06/messages",
          :"@xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
          :"@xsi:schemaLocation" => "http://www.hotelbeds.com/schemas/2005/06/messages #{operation.namespace}.xsd",
          :"@echoToken" => "DummyEchoToken",
          :"@sessionId" => "DummySessionId",
          :Credentials => {
            :User => config.username,
            :Password => config.password
          }
        } }.merge(operation.message)
      })
    end
  end
end