require "hotel_beds/parser"

module HotelBeds
  module Parser
    class CancellationPolicy
      include HotelBeds::Parser

      # attributes
      attribute :amount, selector: "Price > Amount"
      attribute :from do |doc|
        el = doc.at_css("DateTimeFrom")
        v, year, month, day = *el.attr("date").match(/^(\d{4})(\d{2})(\d{2})$/)
        if el.attr("time")
          v, hour, minute = *el.attr("time").match(/^(\d{2})(\d{2})$/)
        else
          hour, minute = 0, 0
        end
        Time.new(year, month, day, hour, minute)
      end
      attribute :to do |doc|
        el = doc.at_css("DateTimeTo")
        v, year, month, day = *el.attr("date").match(/^(\d{4})(\d{2})(\d{2})$/)
        if el.attr("time")
          v, hour, minute = *el.attr("time").match(/^(\d{2})(\d{2})$/)
        else
          hour, minute = 23, 59
        end
        Time.new(year, month, day, hour, minute)
      end
    end
  end
end
