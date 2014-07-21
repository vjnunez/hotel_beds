require "hotel_beds"

RSpec.describe "performing a grouped hotel search" do
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
      @operation = @client.perform_hotel_search({
        check_in_date: @check_in_date,
        check_out_date: @check_out_date,
        rooms: [
          { adult_count: 2 },
          { adult_count: 1, child_count: 1, child_ages: [rand(17)] }
        ],
        destination: "SYD",
        group_results: true
      })
      if @operation.errors.any?
        raise StandardError, @operation.errors.full_messages.join("\n")
      end
      @response = @operation.response
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

      it "should have room counts to match the searched room count" do
        room_counts = subject.map { |h| h.results.map { |r| r.rooms.size } }
        expect(room_counts.to_a.flatten.uniq).to eq([response.request.rooms.size])
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
