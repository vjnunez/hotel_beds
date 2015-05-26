require "virtus"
require "active_model"

module HotelBeds
  module Model
    def self.included(base)
      base.class_eval do
        include Virtus.model
        include ActiveModel::Validations
      end
    end

    def deep_attributes
      attributes.each_with_object(Hash.new) do |(key, value), result|
        if value.respond_to?(:deep_attributes)
          result[key] = value.deep_attributes
        else
          result[key] = value
        end
      end
    end
  end
end
