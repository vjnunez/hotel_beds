require "hotel_beds/model"

module HotelBeds
  module Model
    class Comment
      include HotelBeds::Model

      # attributes
      attribute :type, String
      attribute :content, String
    end
  end
end
