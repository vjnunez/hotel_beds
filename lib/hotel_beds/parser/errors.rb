require "active_model/errors"

module HotelBeds
  module Parser
    class Errors
      attr_accessor :response
      private :response=

      def initialize(response)
        self.response = response
        freeze
      end

      def to_model(object)
        ActiveModel::Errors.new(object).tap do |errors|
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
      end

      private
      def body
        Nokogiri::XML(response.body.values.first)
      end
    end
  end
end
