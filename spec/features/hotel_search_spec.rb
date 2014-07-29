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
      @check_in_date = Date.today + 28 + rand(10)
      @check_out_date = @check_in_date + rand(3) + rand(2) + 1
      @response = @client.perform_hotel_search({
        check_in_date: @check_in_date,
        check_out_date: @check_out_date,
        rooms: [{ adult_count: 2 }],
        destination: "SYD"
      }).response
    end

    let(:check_in_date) { @check_in_date }
    let(:check_out_date) { @check_out_date }
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

      it "should only have one room per result" do
        room_counts = subject.map { |h| h.results.map { |r| r.rooms.size } }
        expect(room_counts.to_a.flatten.uniq).to eq([1])
      end

      it "should have an availability token" do
        subject.each do |hotel|
          expect(hotel.availability_token).to be_present
        end
      end

      it "should have a contract name" do
        subject.each do |hotel|
          expect(hotel.contract_name).to be_present
        end
      end

      it "should have a contract incoming office code" do
        subject.each do |hotel|
          expect(hotel.contract_incoming_office_code).to be_present
        end
      end

      describe "#results" do
        describe "#rooms" do
          subject { response.hotels.first.results.first.rooms.first }

          it "should parse the rates correctly" do
            expect(subject.price).to eq(subject.rates.values.inject(:+))
          end

          it "should have the same number of rates as nights requested" do
            expect(subject.rates.size).to eq(check_out_date - check_in_date)
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
