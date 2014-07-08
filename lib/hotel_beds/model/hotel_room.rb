require "virtus"

module HotelBeds
  module Model
    class HotelRoom
      # attributes
      include Virtus.model
      attribute :id, Integer
      attribute :description, String
      attribute :board, String
      attribute :price, BigDecimal
    end
  end
end
