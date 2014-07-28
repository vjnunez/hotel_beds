require "hotel_beds/model"

module HotelBeds
  module BasketAdd
    class Request
      class HotelService
        include HotelBeds::Model

        # attributes
        attribute :availability_token, String
        attribute :contract_name, String
        attribute :contract_incoming_office_code, String
        attribute :check_in_date, Date
        attribute :check_out_date, Date
        attribute :hotel, String
        attribute :destination, String

        # validation
        validates :destination, length: { is: 3 }
        validates :availability_token, :contract_name,
          :contract_incoming_office_code, :check_in_date, :check_out_date,
          :hotel, presence: true
      end

      include HotelBeds::Model

      # attributes
      attribute :language, String, default: "ENG"
      attribute :service, HotelService

      # validation
      validates :language, length: { is: 3 }
      validates :service, presence: true
    end
  end
end
