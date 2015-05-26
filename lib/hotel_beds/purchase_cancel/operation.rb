require "hotel_beds/action/operation"
require_relative "envelope"
require_relative "request"
require_relative "response"

module HotelBeds
  module PurchaseCancel
    class Operation < HotelBeds::Action::Operation
      remote_method :purchaseCancel
      remote_namespace :PurchaseCancelRQ
      envelope_class Envelope
      request_class Request
      response_class Response
    end
  end
end
