require "hotel_beds"

RSpec.describe "performing a hotel search" do
  let(:check_in_date) { Date.today + 28 + rand(10) }
  let(:check_out_date) { check_in_date + rand(3) + 1 }
  let(:client) do
    HotelBeds::Client.new({
      endpoint: :test,
      username: ENV.fetch("HOTEL_BEDS_USERNAME"),
      password: ENV.fetch("HOTEL_BEDS_PASSWORD"),
      proxy: ENV.fetch("HOTEL_BEDS_PROXY", nil)
    })
  end
  
  let(:search) do
    HotelBeds::Model::Search.new({
      check_in_date: check_in_date,
      check_out_date: check_out_date,
      rooms: [{ adult_count: 2 }],
      destination: "SYD"
    })
  end
  
  let(:response) { client.perform(search) }

  describe "#hotels" do
    subject { response.hotels }

    it "should return an array of the hotels available" do
      expect(subject.to_a).to be_kind_of(Array)
      expect(subject.first).to be_kind_of(HotelBeds::Model::Hotel)
    end
  end
  
  describe "#current_page" do
    subject { response.current_page }

    it "should return '1'" do
      expect(subject).to eq(1)
    end
  end
  
  describe "#total_pages" do
    subject { response.total_pages }

    it "should be greater or equal to current page" do
      expect(subject).to be >= response.current_page
    end
  end
end
