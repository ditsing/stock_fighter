require 'stock_fighter/api_mixin'

include StockFighter::ApiMixin

# Set your API key.
set_api_key "your_api_key_here"

# Test if the service is up.
ok = send_heartbeat.parsed_response["ok"] rescue false

raise "Can't sent heart beat" unless ok

# Get the current orderbook.
orderbook = get_orderbook "TESTEX", "FOOBAR"

raise "Can't get orderbook" unless orderbook["ok"]

p "bids: ", orderbook["bids"]
p "asks: ", orderbook["asks"]

# Place an order!
# By default the direction is 'buy' and order type is 'limit'.
order = place_order "TESTEX", "FOOBAR", "account", price: 100, qty: 1, direction: :buy, order_type: :limit

p order["ok"], order["id"]