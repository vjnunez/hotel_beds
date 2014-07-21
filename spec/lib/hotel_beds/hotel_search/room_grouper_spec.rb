require "hotel_beds/hotel_search/room_grouper"

RSpec.describe HotelBeds::HotelSearch::RoomGrouper do
  subject { described_class.new(requested_rooms, response_rooms).results }

  context "when asking for 2 rooms (2 adults & 1 adult, 1 child)" do
    let(:requested_rooms) do
      [
        double(:requested_room, adult_count: 2, child_count: 0),
        double(:requested_room, adult_count: 1, child_count: 1)
      ]
    end

    let(:response_rooms) do
      [
        double(:response_room_1, id: "room_1", adult_count: 2, child_count: 0, number_available: 1),
        double(:response_room_2, id: "room_2", adult_count: 2, child_count: 0, number_available: 1),
        double(:response_room_3, id: "room_3", adult_count: 1, child_count: 1, number_available: 2),
        double(:response_room_4, id: "room_4", adult_count: 1, child_count: 1, number_available: 1),
        double(:response_room_5, id: "room_5", adult_count: 2, child_count: 0, number_available: 2)
      ]
    end

    it "should return 6 results" do
      expect(subject.size).to eq(6)
    end
  end

  context "when asking for 1 rooms (1 adult, 1 child)" do
    let(:requested_rooms) do
      [double(:requested_room, adult_count: 1, child_count: 1)]
    end

    let(:response_rooms) do
      [
        double(:response_room_1, id: "room_1", adult_count: 1, child_count: 1, number_available: 2),
        double(:response_room_2, id: "room_2", adult_count: 1, child_count: 1, number_available: 1)
      ]
    end

    it "should return 2 results" do
      expect(subject.size).to eq(2)
    end
  end
end
