require "hotel_beds/model"
require_relative "cancellation_policy"

module HotelBeds
  module Model
    class AvailableRoom
      include HotelBeds::Model

      # attributes
      attribute :id, Integer
      attribute :room_count, Integer
      attribute :adult_count, Integer
      attribute :child_count, Integer
      attribute :description, String
      attribute :board, String
      attribute :price, BigDecimal
      attribute :number_available, Integer
      attribute :rates, Hash[Date => BigDecimal]
      attribute :cancellation_policies, Array[CancellationPolicy],
        default: Array.new
    end
  end
end
