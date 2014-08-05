require "hotel_beds/model/room"
require "hotel_beds/model/price"
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

      def rates=(values)
        if values.kind_of?(Array)
          prices = values.map do |attrs|
            HotelBeds::Model::Price.new(attrs)
          end
          hash = prices.inject(Hash.new) do |result, price|
            price.dates.each do |date|
              result.merge!(date => price.amount)
            end
            result
          end
          super(hash)
        else
          super
        end
      end
    end
  end
end
