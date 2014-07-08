require "hotel_beds/model_invalid"
require "securerandom"
require "virtus"
require "active_model"

module HotelBeds
  module Model
    class Base
      # generator for random tokens
      RANDOM_TOKEN = -> (model, attr) { SecureRandom.hex[0..15] }

      # returns the operation for this model
      def self.operation_class
        HotelBeds::Operation.const_get(name.split("::").last)
      end
      
      # attributes
      include Virtus.model      
      attribute :session_id, String, default: RANDOM_TOKEN, writer: :private
      attribute :echo_token, String, default: RANDOM_TOKEN, writer: :private
      
      # validation
      include ActiveModel::Validations
      validates :session_id, :echo_token, presence: true
      
      def to_operation
        if valid?
          self.class.operation_class.new(self)
        else
          raise HotelsBeds::ModelInvalid.new(self)
        end
      end
    end
  end
end