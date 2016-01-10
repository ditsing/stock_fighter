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
    end

    def test_base_uri
      stub = stub_request(:get, "https://api.stockfighter.io/ob/api/a")

      @api = TestApi.new
      (@api.send :trading_http).get "/a"
      assert_requested stub
    end

    def test_headers
      stub = stub_request(:get, "./abcd").with(headers: {
        "X-Starfighter-Authorization" => "1234567",
        "Content-type" => "application/json",
      })
      @api.set_api_key  "1234567"
      (@api.send :trading_http).get "/abcd"
      assert_requested stub
    end

    def test_sendheartbeat
      stub = stub_request(:get, "./heartbeat")
      @api.send_heartbeat
      assert_requested stub

      stub = stub_request(:get, "./venues/mock_venue/heartbeat")
      @api.send_venue_heartbeat "mock_venue"
      assert_requested stub
    end

    def test_list_stocks
      stub = stub_request(:get, "./venues/mock_venue/stocks")
      @api.list_stocks "mock_venue"
      assert_requested stub
    end

    def test_get_orderbook
      stub = stub_request(:get, "./venues/mock_venue/stocks/mock_stock")
      @api.get_orderbook "mock_venue", "mock_stock"
      assert_requested stub
    end

    def test_place_order
      stub = stub_request(:post, "./venues/mock_venue/stocks/mock_stock/orders").with(
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
      assert_requested stub

      stub = stub_request(:post, "./venues/mock_venue/stocks/mock_stock2/orders").with(
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
      assert_requested stub
    end

    def test_show_order
      stub = stub_request(:get, "./venues/mock_venue/stocks/mock_stock/orders/19")
      @api.show_order "mock_venue", "mock_stock", "19"
      assert_requested stub
    end

    def test_cancel_order
      stub = stub_request(:delete, "./venues/mock_venue/stocks/mock_stock/orders/19")
      @api.cancel_order "mock_venue", "mock_stock", "19"
      assert_requested stub
    end

    def test_get_quote
      stub = stub_request(:get, "./venues/mock_venue/stocks/mock_stock/quote")
      @api.get_quote "mock_venue", "mock_stock"
      assert_requested stub
    end

    def test_list_account_orders
      stub = stub_request(:get, "./venues/mock_venue/accounts/mock-account/orders")
      @api.list_account_orders "mock_venue", "mock-account"
      assert_requested stub
    end

    def test_list_account_stock_orders
      stub = stub_request(:get, "./venues/mock_venue/accounts/mock-account/stocks/mock_stock/orders")
      @api.list_account_stock_orders "mock_venue", "mock-account", "mock_stock"
      assert_requested stub
    end
  end
end
