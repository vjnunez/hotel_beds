require "hotel_beds/model"

RSpec.describe HotelBeds::Model do
  describe "#deep_attributes" do
    let(:attributes) do
      Hash({ nested: { nested_again: { title: "test" } } })
    end

    let(:instance_with_nesting) do
      base = Class.new { include HotelBeds::Model }
      deeply_nested = Class.new(base) { attribute :title, String }
      nested = Class.new(base) { attribute :nested_again, deeply_nested }
      Class.new(base) { attribute :nested, nested }.new(attributes)
    end

    subject { instance_with_nesting.deep_attributes }

    it "should return a nested hash of attributes" do
      expect(subject).to eq(attributes)
    end
  end
end
