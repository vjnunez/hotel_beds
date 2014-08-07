require "hotel_beds/action/response"

module HotelBeds
  module PurchaseFlush
    class Response < HotelBeds::Action::Response
      def success?
        super && body.at_css("Status").content == "Y"
      end
    end
  end
end
