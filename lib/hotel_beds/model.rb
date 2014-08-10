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
      attributes.inject(Hash.new) do |result, (key, value)|
        if value.respond_to?(:deep_attributes)
          result.merge(key => value.deep_attributes)
        else
          result.merge(key => value)
        end
      end
    end
  end
end
