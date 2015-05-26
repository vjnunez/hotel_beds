require "hotel_beds/connection"

RSpec.describe HotelBeds::Connection do
  let(:configuration) do
    instance_double("HotelBeds::Configuration", {
      endpoint: "http://www.example.com:2345/api",
      response_timeout: 10,
      request_timeout: 2,
      proxy: "http://example.com:9090/proxy",
      proxy?: true,
      enable_logging?: false
    })
  end
  
  subject { described_class.new(configuration) }
  
  it "should be immutable" do
    expect(subject).to be_frozen
  end
  
  it "should respond to #call" do
    expect(subject).to respond_to(:call)
  end
end
