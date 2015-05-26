require "stringio"
require "ox"
require "hotel_beds/xml_handler"

RSpec.describe HotelBeds::XmlHandler do
  let(:io) do
    StringIO.new(%Q(
      <root name="Test">
        <inner value="6">
          <attr>contained text</attr>
          <ignore>me</ignore>
          <alsoignore />
          <boolean yes="true" no="false" />
        </inner>

        <urls>
          <url>http://example.com/123</url>
          <url>http://example.com/456</url>
          <non-url>A label</non-url>
        </urls>

        <images>
          <image src="http://example.com/123.jpg" />
          <image src="http://example.com/456.jpg" />
          <image />
        </image>
      </root>
    ))
  end

  let(:object) do
    Class.new do
      class Property
        attr_accessor :name, :attribute, :selectors, :array, :content
        attr_reader :value
        private :name=, :attribute=, :selectors=, :array=, :content=

        def initialize(name:, selectors:, attribute: nil, array: false, content: false)
          self.name = name.to_sym
          self.selectors = selectors.map(&:to_sym)
          self.attribute = attribute.to_sym if attribute
          self.array = !!array
          self.content = !!content
          @value = Array.new if array?
        end

        def value=(value)
          if array?
            @value.push(value)
          else
            @value = value
          end
        end

        def content?
          !!content
        end

        def array?
          !!array
        end
      end

      def properties
        @properties ||= [
          Property.new(name: :name, attribute: :name, selectors: %w(root)),
          Property.new(name: :value, attribute: :value, selectors: %w(root inner)),
          Property.new(name: :contents, content: true, selectors: %w(root inner attr)),
          Property.new(name: :yes, attribute: :yes, selectors: %w(root inner boolean)),
          Property.new(name: :no, attribute: :no, selectors: %w(root inner boolean)),
          Property.new(name: :urls, content: true, selectors: %w(root urls url), array: true),
          Property.new(name: :image_urls, attribute: :src, selectors: %w(root images image), array: true),
        ]
      end

      def method_missing(name, *args, &block)
        if args.size == 0 && !block_given? && (property = properties.find { |p| p.name == name.to_sym })
          property.value
        else
          super
        end
      end
    end.new
  end

  let(:handler) { HotelBeds::XmlHandler.new(object) }

  before(:each) { Ox.sax_parse(handler, io) }

  it "should parse out the properties correctly" do
    expect(object.name).to eq("Test")
    expect(object.value).to eq("6")
    expect(object.contents).to eq("contained text")
    expect(object.yes).to eq("true")
    expect(object.no).to eq("false")
    expect(object.urls).to eq(["http://example.com/123", "http://example.com/456"])
    expect(object.image_urls).to eq(["http://example.com/123.jpg", "http://example.com/456.jpg"])
  end
end
