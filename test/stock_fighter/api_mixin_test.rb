require 'minitest/autorun'
require 'test_helper'
require 'stock_fighter/api_mixin'

module StockFighter
  class ApiMixin::Test < MiniTest::Test
    class TestApi
      include ApiMixin
    end

    def setup
      @api = TestApi.new
    end

    def test_separated_endpoint
      trading_stub = stub_request :get, "https://api.stockfighter.io/ob/api/heartbeat"
      game_master_stub = stub_request :post, "https://www.stockfighter.io/gm/levels/first_steps"

      @api.send_heartbeat
      @api.start_current_level

      assert_requested trading_stub
      assert_requested game_master_stub
    end

    def test_different_http_delegator
      api2 = TestApi.new

      refute_equal (@api.send :trading_http), (api2.send :trading_http)
      refute_equal (@api.send :game_master_http), (api2.send :game_master_http)
    end

    def test_share_http_delegator
      TestApi.send :share_class_http_delegator
      api2 = TestApi.new

      assert_equal (@api.send :trading_http), (api2.send :trading_http)
      assert_equal (@api.send :game_master_http), (api2.send :game_master_http)
    end
  end
end
