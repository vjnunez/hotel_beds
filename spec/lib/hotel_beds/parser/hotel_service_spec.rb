require "nokogiri"
require "ostruct"
require "hotel_beds/parser/hotel_service"

RSpec.describe HotelBeds::Parser::HotelService do
  let(:source) do
    %Q(<Service xsi:type="#{attrs[:type]}" SPUI="#{attrs[:id]}">
      <Contract>
        <Name>#{attrs[:contract_name]}</Name>
        <IncomingOffice code="#{attrs[:contract_incoming_office_code]}" />
      </Contract>

      <DateFrom date="#{attrs[:check_in_date]}" />
      <DateTo date="#{attrs[:check_out_date]}" />
      <Currency code="#{attrs[:currency]}">Great British Pounds</Currency>
      <TotalAmount>#{attrs[:amount]}</TotalAmount>
    </Service>)
  end

  let(:attrs) do
    {
      id: "123",
      type: "ServiceHotel",
      contract_name: "Test",
      contract_incoming_office_code: "Big Corp",
      check_in_date: "20140505",
      check_out_date: "20140506",
      currency: "GBP",
      amount: "123.45"
    }
  end

  let(:parser) do
    described_class.new(Nokogiri::XML(source).at_css("HotelService"))
  end

  describe "#to_model" do
    subject { parser.to_model(model_class) }
    let(:model_class) { OpenStruct }

    it "should insert the data into the given class" do
      expect(subject).to be_kind_of(model_class)
    end
  end
end
