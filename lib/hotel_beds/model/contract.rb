require "hotel_beds/model"
require "hotel_beds/model/comment"

module HotelBeds
  module Model
    class Contract
      include HotelBeds::Model

      # attributes
      attribute :name, String
      attribute :incoming_office_code, String
      attribute :comments, Array[HotelBeds::Model::Comment]
    end
  end
end
