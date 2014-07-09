[![Codeship Status](https://www.codeship.io/projects/808271e0-e973-0131-1052-5240ebfefa5a/status)](https://www.codeship.io/projects/26188) [![Code Climate](https://codeclimate.com/github/platformq/hotel_beds.png)](https://codeclimate.com/github/platformq/hotel_beds) [![Code Climate](https://codeclimate.com/github/platformq/hotel_beds/coverage.png)](https://codeclimate.com/github/platformq/hotel_beds)

The `hotel_beds` gem interfaces with the [HotelBeds.com](http://www.hotelbeds.com/) SOAP API to search for and book hotel rooms.

## Installation

I'm sure you know how to install Ruby gems by now...

In your Gemfile, before a `bundle install`, add:

    gem "hotel_beds", "~> 0.0.1"

Manually, via command line:

    gem install hotel_beds

## Usage

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

## Contributing

1. [Fork it](https://github.com/platformq/hotel_beds/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
