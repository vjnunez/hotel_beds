require "hotel_beds/client"

RSpec.describe HotelBeds::Client do
  let(:username) { "username" }
  let(:password) { "password" }
  
  subject do
    described_class.new(
      username: "username",
      password: "password"
    )
  end

  describe "an instance" do
    it "should be immutable" do
      expect(subject).to be_frozen
    end
  end
  
  describe "#configuration" do
    %w(username password endpoint proxy).each do |key|
      it "should respond to ##{key}" do
        expect(subject.configuration).to respond_to(key) 
      end
    end
  end
end
