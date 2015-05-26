require "hotel_beds"
require "securerandom"

RSpec.describe "ordering a hotel room" do
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
      @search_operation = @client.perform_hotel_search({
        check_in_date: @check_in_date,
        check_out_date: @check_out_date,
        rooms: [{ adult_count: 2 }],
        destination_code: "SYD"
      })
      if @search_operation.errors.any?
        raise StandardError, @search_operation.errors.full_messages.join("\n")
      end
      @search_response = @search_operation.response

      hotel = @search_response.hotels.first
      rooms = hotel.available_rooms.first

      @basket_operation = @client.add_hotel_room_to_basket({
        service: {
          check_in_date: @check_in_date,
          check_out_date: @check_out_date,
          availability_token: hotel.availability_token,
          hotel_code: hotel.code,
          destination_code: hotel.destination.code,
          contract_name: hotel.contract.name,
          contract_incoming_office_code: hotel.contract.incoming_office_code,
          rooms: rooms
        }
      })
      if @basket_operation.errors.any?
        raise StandardError, @basket_operation.errors.full_messages.join("\n")
      end
      @basket_response = @basket_operation.response

      @service_id = @basket_response.purchase.services.first.id
      @remove_operation = @client.remove_service_from_basket({
        purchase_token: @basket_response.purchase.token,
        service_id: @service_id
      })
      if @remove_operation.errors.any?
        raise StandardError, @remove_operation.errors.full_messages.join("\n")
      end
      @remove_operation = @remove_operation.response
    end

    let(:response) { @remove_operation }
    let(:service_id) { @service_id }

    subject { response }

    it "should be a success" do
      expect(subject).to be_success
    end

    describe "#purchase" do
      subject { response.purchase }

      it "should not have the service that was removed" do
        expect(subject.services.map(&:id)).to_not include(service_id)
      end
    end
  end
end
