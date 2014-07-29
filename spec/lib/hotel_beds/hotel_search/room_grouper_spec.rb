require "hotel_beds/hotel_search/room_grouper"
require "hotel_beds/model/available_room"

RSpec.describe HotelBeds::HotelSearch::RoomGrouper do
  subject { described_class.new(requested_rooms, response_rooms).results }

  context "when asking for 3 rooms (2 x 2 adults & 1 x 1 adult, 1 child)" do
    let(:requested_rooms) do
      [
        double(:requested_room, adult_count: 2, child_count: 0),
        double(:requested_room, adult_count: 2, child_count: 0),
        double(:requested_room, adult_count: 1, child_count: 1)
      ]
    end

    let(:response_rooms) do
      [
        HotelBeds::Model::AvailableRoom.new(id: "room_1", adult_count: 2, child_count: 0, number_available: 1, room_count: 2),
        HotelBeds::Model::AvailableRoom.new(id: "room_2", adult_count: 2, child_count: 0, number_available: 1, room_count: 2),
        HotelBeds::Model::AvailableRoom.new(id: "room_3", adult_count: 1, child_count: 1, number_available: 2, room_count: 1),
        HotelBeds::Model::AvailableRoom.new(id: "room_4", adult_count: 1, child_count: 1, number_available: 1, room_count: 1),
        HotelBeds::Model::AvailableRoom.new(id: "room_5", adult_count: 2, child_count: 0, number_available: 2, room_count: 2)
      ]
    end

    it "should return 6 results" do
      expect(subject.size).to eq(6)
    end

    it "should return results containing all three rooms" do
      subject.each do |rooms|
        expect(rooms.size).to eq(3)
      end
    end
  end

  context "when asking for 1 rooms (1 adult, 1 child)" do
    let(:requested_rooms) do
      [double(:requested_room, adult_count: 1, child_count: 1)]
    end

    let(:response_rooms) do
      [
        HotelBeds::Model::AvailableRoom.new(id: "room_1", room_count: 1, adult_count: 1, child_count: 1, number_available: 2),
        HotelBeds::Model::AvailableRoom.new(id: "room_2", room_count: 1, adult_count: 1, child_count: 1, number_available: 1)
      ]
    end

    it "should return 2 results" do
      expect(subject.size).to eq(2)
    end
  end
end
