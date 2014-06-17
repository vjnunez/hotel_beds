require "hotel_beds/model/search"
require "date"

RSpec.describe HotelBeds::Model::Search do
  let(:valid_attributes) do
    {
      page_number: 2,
      language: "FRA",
      check_in_date: Date.today,
      check_out_date: Date.today + 2,
      destination: "SYD",
      rooms: [{
        adult_count: 2,
        child_count: 1,
        child_ages: [3]
      }]
    }
  end

  describe "a valid instance" do
    subject { described_class.new(valid_attributes) }
    
    it "should be valid" do
      expect(subject).to be_valid
    end
  end
  
  describe "an instance missing rooms" do
    subject { described_class.new(valid_attributes.merge(rooms: [])) }
    
    it "should not be valid" do
      expect(subject).to_not be_valid
    end
  end
end
