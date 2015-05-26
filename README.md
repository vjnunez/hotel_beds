[![Codeship Status](https://www.codeship.io/projects/808271e0-e973-0131-1052-5240ebfefa5a/status)](https://www.codeship.io/projects/26188) [![Gem Version](https://badge.fury.io/rb/hotel_beds.svg)](https://rubygems.org/gems/hotel_beds) [![Code Climate](https://codeclimate.com/github/platformq/hotel_beds/badges/gpa.svg)](https://codeclimate.com/github/platformq/hotel_beds) [![Code Climate](https://codeclimate.com/github/platformq/hotel_beds/badges/coverage.svg)](https://codeclimate.com/github/platformq/hotel_beds)

**NOTE: This gem is no longer under active development. Feel free to fork and continue development.**

The `hotel_beds` gem interfaces with the [HotelBeds.com](http://www.hotelbeds.com/) SOAP API to search for and book hotel rooms.

## Installation

I'm sure you know how to install Ruby gems by now...

In your Gemfile, before a `bundle install`, add:

    gem "hotel_beds", "~> X.X.X"

**Note:** you'll need to replace `X.X.X` in the example above with the [latest gem version](https://rubygems.org/gems/hotel_beds) visible in the badge above.

Manually, via command line:

    gem install hotel_beds

## Usage

It's best to check the [feature specs](https://github.com/platformq/hotel_beds/tree/master/spec/features) to see up-to-date examples, but a basic search example is below:

```ruby
# create the connection to HotelBeds
client = HotelBeds::Client.new(endpoint: :test, username: "user", password: "pass")

# perform the search
search = client.perform_hotel_search({
  check_in_date: Date.today,
  check_out_date: Date.today + 1,
  rooms: [{ adult_count: 2 }],
  destination_code: "SYD"
})

# inspect the response
puts search.response.hotels
# => [<HotelBeds::Model::Hotel>, <HotelBeds::Model::Hotel>]
puts search.response.total_pages
# => 10
puts search.response.current_page
# => 1
```

## Contributing

1. [Fork it](https://github.com/platformq/hotel_beds/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
