The `hotel_beds` gem interfaces with the [HotelBeds.com](http://www.hotelbeds.com/) SOAP API to search for and book hotel rooms.

## Installation

I'm sure you know how to install Ruby gems by now...

In your Gemfile, before a `bundle install`, add:

    gem "hotel_beds", "~> 0.0.1"

Manually, via command line:

    gem install hotel_beds

## Usage

    client = HotelBeds::Client.new(endpoint: :test, username: "user", password: "pass")

## Contributing

1. [Fork it](https://github.com/platformq/hotel_beds/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
