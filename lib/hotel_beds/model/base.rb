require "hotel_beds/model_invalid"
require "securerandom"
require "virtus"
require "active_model"

module HotelBeds
  module Model
    class Base
      def self.operation_class
        HotelBeds::Operation.const_get(name.split("::").last)
      end
      
      # attributes
      include Virtus.model      
      attribute :session_id, String, {
        default: -> (model, attr) { SecureRandom.uuid },
        writer: :private
      }
      attribute :echo_token, String, {
        default: -> (model, attr) { SecureRandom.uuid },
        writer: :private
      }
      
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