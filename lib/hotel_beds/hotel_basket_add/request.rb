require "securerandom"
require "hotel_beds/action/request"
require "hotel_beds/model"
require "hotel_beds/model/available_room"

module HotelBeds
  module HotelBasketAdd
    class Request < HotelBeds::Action::Request
      class HotelService
        include HotelBeds::Model

        # attributes
        attribute :availability_token, String
        attribute :contract_name, String
        attribute :contract_incoming_office_code, String
        attribute :check_in_date, Date
        attribute :check_out_date, Date
        attribute :hotel_code, String
        attribute :destination_code, String
        attribute :rooms, Array[HotelBeds::Model::AvailableRoom]

        # validation
        validates :destination_code, length: { is: 3, allow_blank: false }
        validates :rooms, length: { minimum: 1, maximum: 5 }
        validates :session_id, :availability_token, :contract_name,
          :contract_incoming_office_code, :check_in_date, :check_out_date,
          :hotel_code, presence: true
        validate do |service|
          unless (1..5).cover?(service.rooms.size)
            service.errors.add(:rooms, "quantity must be between 1 and 5")
          end
          unless service.rooms.all?(&:valid?)
            service.errors.add(:rooms, "are invalid")
          end
        end
      end

      # attributes
      attribute :session_id, String, default: SecureRandom.hex[0..15]
      attribute :service, HotelService

      # validation
      validates :session_id, :service, presence: true
    end
  end
end
