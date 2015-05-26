RSpec.describe HotelBeds::VERSION do
  example do
    expect(subject).to match(/\A\d+\.\d+\.\d+(\.\d+)?\z/)
  end
end
