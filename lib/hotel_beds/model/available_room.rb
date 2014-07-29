require "hotel_beds/model/room"
require "hotel_beds/model/cancellation_policy"

module HotelBeds
  module Model
    class AvailableRoom < Room
      # attributes
      attribute :id, Integer
      attribute :room_count, Integer
      attribute :description, String
      attribute :board, String
      attribute :board_code, String
      attribute :room_type_code, String
      attribute :room_type_characteristic, String
      attribute :price, BigDecimal
      attribute :number_available, Integer
      attribute :rates, Hash[Date => BigDecimal]
      attribute :cancellation_policies, Array[CancellationPolicy],
        default: Array.new
    end
  end
end
