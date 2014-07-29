require "hotel_beds/model"

module HotelBeds
  module Model
    class Service
      include HotelBeds::Model

      # attributes
      attribute :id, String
      attribute :contract_name, String
      attribute :contract_incoming_office_code, String
      attribute :check_in_date, Date
      attribute :check_out_date, Date
      attribute :currency, String
      attribute :amount, BigDecimal
    end
  end
end
