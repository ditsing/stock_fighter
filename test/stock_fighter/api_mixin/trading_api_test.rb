require 'minitest/autorun'
require 'test_helper'

module StockFighter::ApiMixin
  class TradingApi::Test < MiniTest::Test
    class TestApi
      include TradingApi
    end

    def setup
      @api = TestApi.new
      (@api.send :trading_http).base_uri "."
      @stubs = []
    end

    def teardown
      @stubs.each do |stub| assert_requested stub end
      @stubs = []
      WebMock.reset!
    end

    def new_stub_request *args
      stub = stub_request(*args)
      @stubs << stub
      stub
    end

    def test_base_uri
      new_stub_request(:get, "https://api.stockfighter.io/ob/api/a")

      @api = TestApi.new
      (@api.send :trading_http).get "/a"
    end

    def test_headers
      new_stub_request(:get, "./abcd").with(headers: {
        "X-Starfighter-Authorization" => "1234567",
        "Content-type" => "application/json",
      })
      @api.set_api_key  "1234567"
      (@api.send :trading_http).get "/abcd"
    end

    def test_sendheartbeat
      new_stub_request(:get, "./heartbeat")
      @api.send_heartbeat

      new_stub_request(:get, "./venues/mock_venue/heartbeat")
      @api.send_venue_heartbeat "mock_venue"
    end

    def test_list_stocks
      new_stub_request(:get, "./venues/mock_venue/stocks")
      @api.list_stocks "mock_venue"
    end

    def test_get_orderbook
      new_stub_request(:get, "./venues/mock_venue/stocks/mock_stock")
      @api.get_orderbook "mock_venue", "mock_stock"
    end

    def test_place_order
      new_stub_request(:post, "./venues/mock_venue/stocks/mock_stock/orders").with(
        body: {
          "venue" => "mock_venue",
          "stock" => "mock_stock",
          "account" => "mock-account",
          "price" => 1.9,
          "qty" => 20,
          "direction" => "buy",
          "orderType" => "limit",
        }
      )
      @api.place_order "mock_venue", "mock_stock", "mock-account", price: 1.9, qty: 20

      new_stub_request(:post, "./venues/mock_venue/stocks/mock_stock2/orders").with(
        body: {
          "venue" => "mock_venue",
          "stock" => "mock_stock2",
          "account" => "mock-account",
          "price" => 1.9,
          "qty" => 20,
          "direction" => "xyz",
          "orderType" => "abcd",
        }
      )
      @api.place_order "mock_venue", "mock_stock2", "mock-account", price: 1.9, qty: 20,
        direction: :xyz, order_type: "abcd"
    end

    def test_show_order
      new_stub_request(:get, "./venues/mock_venue/stocks/mock_stock/orders/19")
      @api.show_order "mock_venue", "mock_stock", "19"
    end

    def test_cancel_order
      new_stub_request(:delete, "./venues/mock_venue/stocks/mock_stock/orders/19")
      @api.cancel_order "mock_venue", "mock_stock", "19"
    end

    def test_get_quote
      new_stub_request(:get, "./venues/mock_venue/stocks/mock_stock/quote")
      @api.get_quote "mock_venue", "mock_stock"
    end

    def test_list_account_orders
      new_stub_request(:get, "./venues/mock_venue/accounts/mock-account/orders")
      @api.list_account_orders "mock_venue", "mock-account"
    end

    def test_list_account_stock_orders
      new_stub_request(:get, "./venues/mock_venue/accounts/mock-account/stocks/mock_stock/orders")
      @api.list_account_stock_orders "mock_venue", "mock-account", "mock_stock"
    end
  end
end
