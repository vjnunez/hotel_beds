require "hotel_beds/model"

module HotelBeds
  module Model
    class Room
      include HotelBeds::Model

      # attributes
      attribute :adult_count, Integer, default: 0
      attribute :child_count, Integer, default: 0
      attribute :child_ages, Array[Integer], default: Array.new

      # validation
      validates :adult_count, :child_count, numericality: {
        greater_than_or_equal_to: 0,
        less_than_or_equal_to: 20,
        only_integer: true,
      }
      validate do |room|
        unless child_ages.compact.size == child_count
          room.errors.add(:child_ages, "must match quantity of children")
        end
      end

      def group_key
        { adult_count: adult_count, child_count: child_count }
      end
    end
  end
end
