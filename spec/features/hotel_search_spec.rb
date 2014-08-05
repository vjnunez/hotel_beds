require "hotel_beds"

RSpec.describe "performing a hotel search" do
  describe "#response" do
    before(:all) do
      @client = HotelBeds::Client.new({
        endpoint: :test,
        username: ENV.fetch("HOTEL_BEDS_USERNAME"),
        password: ENV.fetch("HOTEL_BEDS_PASSWORD"),
        proxy: ENV.fetch("HOTEL_BEDS_PROXY", nil)
      })
      @stay_length_in_days = rand(3) + 1
      @check_in_date = Date.today + 28 + rand(10)
      @check_out_date = @check_in_date + @stay_length_in_days
      @requested_rooms = [HotelBeds::Model::RequestedRoom.new({ adult_count: 2 })]
      @response = @client.perform_hotel_search({
        check_in_date: @check_in_date,
        check_out_date: @check_out_date,
        rooms: @requested_rooms,
        destination_code: "SYD"
      }).response
    end

    let(:check_in_date) { @check_in_date }
    let(:check_out_date) { @check_out_date }
    let(:requested_rooms) { @requested_rooms }
    let(:stay_length_in_days) { @stay_length_in_days }
    let(:response) { @response }

    describe "#errors" do
      subject { response.errors }

      it "should be empty" do
        expect(subject).to be_empty
      end
    end

    describe "#hotels" do
      subject { response.hotels }

      it "should return an array of the hotels available" do
        expect(subject.to_a).to be_kind_of(Array)
        expect(subject.to_a).to_not be_empty
        expect(subject.first).to be_kind_of(HotelBeds::Model::Hotel)
      end

      it "should have a destination code" do
        subject.each do |hotel|
          expect(hotel.destination.code).to be_present
        end
      end

      it "should have an availability token" do
        subject.each do |hotel|
          expect(hotel.availability_token).to be_present
        end
      end

      it "should have a contract name" do
        subject.each do |hotel|
          expect(hotel.contract.name).to be_present
        end
      end

      it "should have a contract incoming office code" do
        subject.each do |hotel|
          expect(hotel.contract.incoming_office_code).to be_present
        end
      end

      describe "#rooms" do
        subject do
          response.hotels.map(&:available_rooms).to_a.flatten
        end

        it "should have a price > 0" do
          subject.each do |room|
            expect(room.price).to be > 0
          end
        end

        it "should parse the rates correctly" do
          subject.each do |room|
            expect(room.rates.values.inject(BigDecimal.new("0"), :+)).to eq(room.price)
          end
        end

        it "should have the same number of rates as nights requested" do
          subject.each do |room|
            expect(room.rates).to_not be_empty
            expect(room.rates.size).to eq(stay_length_in_days)
          end
        end
      end

      describe "#grouped_rooms" do
        subject do
          response.hotels.map do |h|
            h.grouped_rooms(requested_rooms)
          end
        end

        let(:requested_adult_count) { requested_rooms.map(&:adult_count).inject(0, :+) }
        let(:requested_child_count) { requested_rooms.map(&:child_count).inject(0, :+) }

        it "should return sets of rooms matching the requested rooms" do
          subject.each do |results|
            results.each do |result|
              expect(result.size).to eq(requested_rooms.size)
              expect(result.map(&:adult_count).inject(0, :+)).to eq(requested_adult_count)
              expect(result.map(&:child_count).inject(0, :+)).to eq(requested_child_count)
            end
          end
        end
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
end
