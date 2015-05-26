require "hotel_beds/action/operation"
require_relative "envelope"
require_relative "request"
require_relative "response"

module HotelBeds
  module PurchaseFlush
    class Operation < HotelBeds::Action::Operation
      remote_method :purchaseFlush
      remote_namespace :PurchaseFlushRQ
      envelope_class Envelope
      request_class Request
      response_class Response
    end
  end
end
