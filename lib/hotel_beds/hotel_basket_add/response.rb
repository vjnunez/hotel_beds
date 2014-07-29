require "active_model/errors"
require "hotel_beds/model/purchase"

module HotelBeds
  module HotelBasketAdd
    class Response
      attr_accessor :request, :headers, :body, :errors
      private :request=, :headers=, :body=, :errors=

      def initialize(request, response)
        self.request = request
        self.headers = response.header
        self.body = Nokogiri::XML(response.body.fetch(:service_add))
        self.errors = ActiveModel::Errors.new(self).tap do |errors|
          if response.http_error?
            errors.add(:base, "HTTP error")
          elsif response.soap_fault?
            errors.add(:base, "SOAP error")
          elsif !response.success?
            errors.add(:base, "Request failed")
          end

          body.css("ErrorList Error").each do |error|
            errors.add(:base, [
              (sm = error.at_css("Message")) && sm.content,
              (dm = error.at_css("DetailedMessage")) && dm.content
            ].compact.join("\n"))
          end
        end
        freeze
      end

      def inspect
        "<#{self.class.name} errors=#{errors.inspect} headers=#{headers.inspect} body=#{body.to_s}>"
      end

      def session_id
        request.session_id
      end

      def success?
        errors.empty?
      end

      def purchase
        purchase = body.at_css("Purchase")
        HotelBeds::Model::Purchase.new({
          id: purchase.attr("purchaseToken"),
          currency: purchase.at_css("Currency").attr("code"),
          amount: purchase.at_css("TotalPrice").content,
          services: purchase.css("ServiceList Service").map { |service|
            {
              id: service.attr("SPUI"),
              contract_name: service.at_css("Contract Name").content,
              contract_incoming_office_code: service.at_css("Contract IncomingOffice").attr("code"),
              check_in_date: Date.parse(service.at_css("DateFrom").attr("date")),
              check_out_date: Date.parse(service.at_css("DateTo").attr("date")),
              currency: service.at_css("Currency").attr("code"),
              amount: service.at_css("TotalAmount").content
            }
          }
        })
      end
    end
  end
end
