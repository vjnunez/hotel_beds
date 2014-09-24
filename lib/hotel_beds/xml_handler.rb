require "ox"

module HotelBeds
  class XmlHandler < ::Ox::Sax
    attr_accessor :object, :selectors

    def initialize(object)
      self.object = object
      self.selectors = Array.new
    end

    def start_element(name)
      self.selectors.push(name.to_sym)
    end

    def end_element(name)
      self.selectors.pop
    end

    def attr(name, value)
      object.properties.select do |property|
        selectors == property.selectors && name.to_sym == property.attribute
      end.each do |property|
        property.value = value
      end
    end

    def text(value)
      object.properties.select do |property|
        selectors == property.selectors && :content == property.attribute
      end.each do |property|
        property.value = value
      end
    end
  end
end
