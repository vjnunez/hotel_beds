require "active_model/errors"

module HotelBeds
  module HotelSearch
    module Parser
      class Errors
        def self.call(*args, &block)
          new(*args, &block).call
        end

        attr_accessor :response, :body
        private :response, :body

        def initialize(response, body)
          self.response = response
          self.body = body
          freeze
        end

        def call
          ActiveModel::Errors.new(self).tap do |errors|
            apply_response_errors(errors)
            apply_body_errors(errors)
          end.freeze
        end

        private
        def apply_response_errors(errors)
          if response.http_error?
            errors.add(:base, "HTTP error")
          elsif response.soap_fault?
            errors.add(:base, "SOAP error")
          elsif !response.success?
            errors.add(:base, "Request failed")
          end
        end

        def apply_body_errors(errors)
          body.css("ErrorList Error").each do |error|
            errors.add(:base, [
              (sm = error.at_css("Message")) && sm.content,
              (dm = error.at_css("DetailedMessage")) && dm.content
            ].compact.join("\n"))
          end
        end
      end
    end
  end
end
