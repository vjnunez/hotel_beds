require "hotel_beds/action/envelope"

module HotelBeds
  module PurchaseCancel
    class Envelope < HotelBeds::Action::Envelope
      def attributes
        {
          :@type => 'C',
          Language: language,
          PurchaseReference: {
            :FileNumber => purchase_reference.file_number,
            :IncomingOffice => {
              :@code => purchase_reference.incoming_office
            }
          }
        }
      end
    end
  end
end
