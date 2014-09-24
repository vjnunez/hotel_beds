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
      </root>
    ))
  end

  let(:object) do
    Class.new do
      class Property
        attr_accessor :name, :attribute, :selectors, :value

        def initialize(name:, attribute:, selectors:)
          self.name = name.to_sym
          self.attribute = attribute.to_sym
          self.selectors = selectors.map(&:to_sym)
        end
      end

      def properties
        @properties ||= [
          Property.new(name: :name, attribute: :name, selectors: %w(root)),
          Property.new(name: :value, attribute: :value, selectors: %w(root inner)),
          Property.new(name: :contents, attribute: :content, selectors: %w(root inner attr)),
          Property.new(name: :yes, attribute: :yes, selectors: %w(root inner boolean)),
          Property.new(name: :no, attribute: :no, selectors: %w(root inner boolean)),
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
  end
end
