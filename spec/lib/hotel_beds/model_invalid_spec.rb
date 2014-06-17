require "hotel_beds/model_invalid"

RSpec.describe HotelBeds::ModelInvalid do
  let(:model) { Object.new }
  let(:instance) { described_class.new(model) }
  
  describe "an instance" do
    subject { instance }

    it "should be immutable" do
      expect(subject).to be_frozen
    end
  end
  
  describe "#model" do
    subject { instance.model }

    it "should return the given model" do
      expect(subject).to eq(model)
    end
  end
end
