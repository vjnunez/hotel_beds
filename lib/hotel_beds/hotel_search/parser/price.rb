module HotelBeds
  module HotelSearch
    module Parser
      class Price
        def self.call(*args, &block)
          new(*args, &block).call
        end

        attr_accessor :price
        private :price

        def initialize(price)
          self.price = price
          freeze
        end

        def call
          (from..to).to_a.inject(Hash.new) do |result, date|
            result.merge!(date => amount)
          end
        end

        private
        def from
          Date.parse(price.at_css("DateTimeFrom").attr("date"))
        end

        def to
          Date.parse(price.at_css("DateTimeTo").attr("date"))
        end

        def amount
          BigDecimal.new(price.at_css("Amount").content, 3)
        end
      end
    end
  end
end
