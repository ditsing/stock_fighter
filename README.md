# StockFighter

An (unofficial) API for [stockfighter.io](http://stockfighter.io). Designed to be friendly to scripting. Run `bundle exec stock_fighter` (or `bin/console`) and start trading!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stock_fighter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stock_fighter

## Usage for Scripting

See the following script. The code can also be found in `examples/test_exchange.rb`. Detailed API is listed in `lib/stock_fighter/api_mixin.rb`.

```ruby
require 'stock_fighter/api_mixin'

include StockFighter::ApiMixin

# Set your API key.
set_api_key "your_api_key_here"

venue = "TESTEX"
stock = "FOOBAR"
account = "EXB123456"

# Test if the service is up.
ok = send_heartbeat.parsed_response["ok"]

raise "Can't send heartbeat" unless ok

# Get the current orderbook.
orderbook = get_orderbook venue, stock

raise "Can't get orderbook" unless orderbook["ok"]

p "bids: ", orderbook["bids"]
p "asks: ", orderbook["asks"]

# Place an order!
# By default the direction is 'buy' and order type is 'limit'.
order = place_order venue, stock, account, price: 100, qty: 1, direction: :buy, order_type: :limit

# There should be an error unless a valid API key is supplied.
p order
```

As a side effect, all objects will have extra methods :-).

TODO: add examples for more serious coding style.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/stock_fighter.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

