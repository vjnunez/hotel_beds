require "hotel_beds/model"

module HotelBeds
  module Model
    class Price
      include HotelBeds::Model

      # attributes
      attribute :from, Date
      attribute :to, Date
      attribute :amount, BigDecimal

      def dates
        (from..to).to_a
      end
    end
  end
end
