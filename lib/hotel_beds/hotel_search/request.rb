require "hotel_beds/model"

module HotelBeds
  module HotelSearch
    class Request
      class Room
        include HotelBeds::Model

        # attributes
        attribute :adult_count, Integer, default: 0
        attribute :child_count, Integer, default: 0
        attribute :child_ages, Array[Integer], default: Array.new

        # validation
        validates :adult_count, :child_count, numericality: {
          greater_than_or_equal_to: 0,
          less_than_or_equal_to: 4,
          only_integer: true,
        }
        validate do |room|
          unless child_ages.compact.size == child_count
            room.errors.add(:child_ages, "must match quantity of children")
          end
        end
      end

      include HotelBeds::Model

      # attributes
      attribute :page_number, Integer, default: 1
      attribute :language, String, default: "ENG"
      attribute :check_in_date, Date
      attribute :check_out_date, Date
      attribute :destination, String
      attribute :hotels, Array[Integer]
      attribute :rooms, Array[Room]
      attribute :group_results, Virtus::Attribute::Boolean, default: false

      # validation
      validates :language, :destination, length: { is: 3 }
      validates :check_in_date, :check_out_date, presence: true
      validates :rooms, length: { minimum: 1, maximum: 5 }
      validates :page_number, numericality: {
        greater_than: 0, only_integer: true
      }
      validate do |search|
        unless (1..5).cover?(search.rooms.size)
          search.errors.add(:rooms, "quantity must be between 1 and 5")
        end
        unless search.rooms.all?(&:valid?)
          search.errors.add(:rooms, "are invalid")
        end
      end
    end
  end
end
