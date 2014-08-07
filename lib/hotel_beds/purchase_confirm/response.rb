require "hotel_beds/action/response"
require "hotel_beds/parser/purchase"

module HotelBeds
  module PurchaseConfirm
    class Response < HotelBeds::Action::Response
      def purchase
        HotelBeds::Parser::Purchase.new(body.at_css("Purchase")).to_model
      end
    end
  end
end
