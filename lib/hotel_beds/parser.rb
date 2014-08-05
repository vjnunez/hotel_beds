module HotelBeds
  module Parser
    def self.included(base)
      base.extend ClassMethods
      base.send(:include, InstanceMethods)
    end

    module ClassMethods
      class Attribute
        attr_accessor :name, :parser, :selector, :attr, :multiple, :custom
        private :name=, :parser=, :selector=, :attr=, :multiple=, :custom=

        def initialize(name, parser: nil, selector: nil, attr: :content, multiple: false, &block)
          self.name = name.to_sym
          self.parser = parser
          self.selector = selector
          self.attr = attr
          self.multiple = !!multiple
          self.custom = block
          freeze
        end

        def retrieve(doc)
          if custom
            custom.yield(doc)
          elsif multiple
            doc.css(selector).map(&method(:read_element))
          elsif selector
            (element = doc.at_css(selector)) && read_element(element) or nil
          else
            read_element(doc)
          end
        end

        private
        def read_element(element)
          if parser
            parser.new(element).to_h
          elsif attr == :content
            element.content
          else
            element.attr(attr)
          end
        end
      end

      def attributes
        @attributes ||= Array.new
      end

      protected def attribute(*args, &block)
        (@attributes ||= Array.new).push(Attribute.new(*args, &block))
      end

      def default_model_class(klass = nil)
        # set the class, if given
        @default_model_class = klass if klass
        # return the class, defaulting to HotelBeds::Model::ClassName
        @default_model_class ||= begin
          klass_name = name.gsub(/^.*\:\:(.*?)$/, '\1')
          file_name = klass_name.gsub(/(?<=.)([A-Z]+)/, '_\1').downcase
          require "hotel_beds/model/#{file_name}"
          ::HotelBeds.const_get("Model").const_get(klass_name)
        end
      end
    end

    module InstanceMethods
      def self.included(base)
        base.class_eval do
          attr_accessor :doc
          private :doc=
        end
      end

      def initialize(doc)
        self.doc = doc
        freeze
      end

      # parses the document into a hash of attributes
      def to_h
        self.class.attributes.inject(Hash.new) do |result, attribute|
          result.merge(attribute.name => attribute.retrieve(doc))
        end
      end

      # parses the document into a HotelBeds::Model instance
      def to_model(klass = self.class.default_model_class)
        klass.new(to_h)
      end
    end
  end
end
