require "hotel_beds/model"

module HotelBeds
  module Model
    class Customer
      include HotelBeds::Model

      # attributes
      attribute :id, Integer
      attribute :type, Symbol
      attribute :age, Integer
      attribute :name, Integer
      attribute :last_name, Integer

      # validation
      validates :id, :name, :last_name, presence: true
      validates :age, numericality: { greater_than_or_equal_to: 0 }
      validates :type, inclusion: { in: %i(adult child) }
    end
  end
end
