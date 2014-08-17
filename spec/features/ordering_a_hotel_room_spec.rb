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

      @agency_reference = SecureRandom.hex[0..15].upcase
      @checkout_operation = @client.confirm_purchase({
        purchase: {
          agency_reference: @agency_reference,
          token: @basket_response.purchase.token,
          holder: {
            id: "1",
            type: :adult,
            name: "David",
            last_name: "Smith",
            age: "43"
          },
          services: @basket_response.purchase.services.map { |service|
            {
              id: service.id,
              type: service.type,
              customers: [
                { id: "1", type: :adult, name: "David", last_name: "Smith", age: "43" },
                { id: "2", type: :adult, name: "Jane", last_name: "Smith", age: "40" }
              ]
            }
          }
        }
      })
      if @checkout_operation.errors.any?
        raise StandardError, @checkout_operation.errors.full_messages.join("\n")
      end
      @checkout_response = @checkout_operation.response
    end

    describe "basket response" do
      let(:response) { @basket_response }

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

      describe "#purchase.services" do
        subject { response.purchase.services }

        it "should alway have a contract" do
          subject.each do |service|
            expect(service.contract).to_not be_nil
          end
        end
      end

      describe "#purchase.services.available_rooms" do
        subject do
          response.purchase.services.map(&:available_rooms).inject(Array.new, :+)
        end

        it "should have a cancellation policy" do
          subject.each do |room|
            expect(room.cancellation_policies).to_not be_empty
          end
        end
      end
    end

    describe "checkout response" do
      let(:response) { @checkout_response }

      subject { response }

      it "should be a success" do
        expect(subject).to be_success
      end

      describe "#purchase" do
        subject { response.purchase }

        it "should have a reference" do
          expect(subject.reference).to_not be_nil
          expect(subject.reference.file_number).to_not be_empty
        end

        it "should have a service" do
          expect(subject.services).to_not be_empty
        end

        it "should have a agency reference" do
          expect(subject.agency_reference).to eq(@agency_reference)
        end
      end
    end
  end
end
