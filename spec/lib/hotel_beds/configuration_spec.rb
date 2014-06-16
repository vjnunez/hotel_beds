require "hotel_beds/configuration"

RSpec.describe HotelBeds::Configuration do
  let(:endpoint) { "http://example.com/api" }
  let(:username) { "test" }
  let(:password) { "passW0rd" }
  let(:proxy) { "http://example.com/test" }
  
  subject do
    described_class.new(
      endpoint: endpoint,
      username: username,
      password: password,
      proxy: proxy
    )
  end

  describe "an instance" do
    it "should be immutable" do
      expect(subject).to be_frozen
    end
  end
  
  describe "#endpoint" do
    context "with a URL string" do
      it "should return the given endpoint" do
        expect(subject.endpoint).to eq(endpoint)
      end
    end
    
    described_class.endpoints.each do |key,value|
      context "with a :#{key} key" do
        let(:endpoint) { key }

        it "should return the defined endpoint" do
          expect(subject.endpoint).to eq(value)
        end
      end
    end
  end
  
  describe "#username" do
    it "should return the given username" do
      expect(subject.username).to eq(username)
    end
  end
  
  describe "#password" do
    it "should return the given password" do
      expect(subject.password).to eq(password)
    end
  end
  
  describe "#proxy" do
    it "should return the given proxy" do
      expect(subject.proxy).to eq(proxy)
    end
  end
  
  describe "#proxy?" do
    context "when proxy is specified" do
      let(:proxy) { "http://example.com/proxy" }

      it "should return true when a proxy is specified" do
        expect(subject.proxy?).to eq(true)
      end
    end
    
    context "when no proxy is specified" do
      let(:proxy) { nil }

      it "should return false" do
        expect(subject.proxy?).to eq(false)
      end
    end
  end
  
  describe "#request_timeout" do
    it "should default to 5 seconds" do
      expect(subject.request_timeout).to eq(5)
    end
  end
  
  describe "#response_timeout" do
    it "should default to 30 seconds" do
      expect(subject.response_timeout).to eq(30)
    end
  end
end
