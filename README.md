[![Codeship Status](https://www.codeship.io/projects/808271e0-e973-0131-1052-5240ebfefa5a/status)](https://www.codeship.io/projects/26188) [![Gem Version](https://badge.fury.io/rb/hotel_beds.svg)](https://rubygems.org/gems/hotel_beds) [![Code Climate](https://codeclimate.com/github/platformq/hotel_beds.png)](https://codeclimate.com/github/platformq/hotel_beds) [![Code Climate](https://codeclimate.com/github/platformq/hotel_beds/coverage.png)](https://codeclimate.com/github/platformq/hotel_beds)

The `hotel_beds` gem interfaces with the [HotelBeds.com](http://www.hotelbeds.com/) SOAP API to search for and book hotel rooms.

## Installation

I'm sure you know how to install Ruby gems by now...

In your Gemfile, before a `bundle install`, add:

    gem "hotel_beds", "~> X.X.X"

**Note:** you'll need to replace `X.X.X` in the example above with the [latest gem version](https://rubygems.org/gems/hotel_beds) visible in the badge above.

Manually, via command line:

    gem install hotel_beds

## Usage

```ruby
# create the connection to HotelBeds
client = HotelBeds::Client.new(endpoint: :test, username: "user", password: "pass")

# perform the search
search = client.perform_hotel_search({
  check_in_date: Date.today,
  check_out_date: Date.today + 1,
  rooms: [{ adult_count: 2 }],
  destination: "SYD"
})

# inspect the response
puts search.response.hotels
# => [<HotelBeds::Model::Hotel>, <HotelBeds::Model::Hotel>]
puts search.response.total_pages
# => 10
puts search.response.current_page
# => 1

# place a booking
booking = client.perform_hotel_booking({
  room_ids: [search.response.hotels.first.results.first.id],
  people: [
    { title: "Mr", name: "David Smith", type: :adult },
    { title: "Mrs", name: "Jane Smith", type: :adult }
  ],
  address: {
    line_1: "123 Some Street",
    city: "Townsville",
    state: "New Statestown",
    postcode: "NS1 1AB"
    country: "UK"
  },
  phone_number: "+44 1234 567 890",
  email: "david.smith@example.com"
})

# inspect the response
puts booking.response.reference
# => "ABC-123"
```

### Options

The HotelBeds API will return individual rooms, rather than being grouped by what you searched for (e.g. 2 rooms, 1 with 2 adults, 1 with 1 adult and 1 child). To fix this issue, you can enable result grouping by adding `group_results: true` to the `perform_hotel_search` call.

Example:

```ruby
# perform the search
search = client.perform_hotel_search({
  check_in_date: Date.today,
  check_out_date: Date.today + 1,
  rooms: [
    { adult_count: 2 },
    { adult_count: 1, child_count: 1, child_ages: [7] }
  ],
  destination: "SYD",
  group_results: true
})
```

## Contributing

1. [Fork it](https://github.com/platformq/hotel_beds/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
