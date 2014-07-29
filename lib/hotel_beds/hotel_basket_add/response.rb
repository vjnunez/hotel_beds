require "active_model/errors"

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
    end
  end
end
