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
  end
end
