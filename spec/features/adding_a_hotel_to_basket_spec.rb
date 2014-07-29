require "hotel_beds"

RSpec.describe "adding a hotel to the basket" do
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
      @search_response = @client.perform_hotel_search({
        check_in_date: @check_in_date,
        check_out_date: @check_out_date,
        rooms: [{ adult_count: 2 }],
        destination: "SYD"
      }).response

      hotel = @search_response.hotels.first
      result = hotel.results.first

      @operation = @client.add_hotel_room_to_basket({
        service: {
          check_in_date: @check_in_date,
          check_out_date: @check_out_date,
          availability_token: hotel.availability_token,
          hotel_code: hotel.id,
          destination_code: hotel.destination_code,
          contract_name: hotel.contract_name,
          contract_incoming_office_code: hotel.contract_incoming_office_code,
          rooms: result.rooms
        }
      })
      if @operation.errors.any?
        raise StandardError, @operation.errors.full_messages.join("\n")
      end
      @response = @operation.response
    end

    let(:response) { @response }

    subject { response }

    it "should be a success" do
      expect(subject).to be_success
    end

    describe "#purchase" do
      subject { response.purchase }

      it "should have a service" do
        expect(subject.services).to_not be_empty
      end
    end
  end
end
