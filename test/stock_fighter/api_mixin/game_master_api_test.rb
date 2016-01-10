require 'minitest/autorun'
require 'test_helper'

module StockFighter::ApiMixin
  class GameMasterApi::Test < MiniTest::Test
    class TestApi
      include GameMasterApi
    end

    def setup
      @api = TestApi.new
      (@api.send :game_master_http).base_uri "."
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
      new_stub_request(:get, "https://www.stockfighter.io/gm/a")

      @api = TestApi.new
      (@api.send :game_master_http).get "/a"
    end

    def test_start_current_level
      new_stub_request(:post, "./levels/first_steps")

      @api.start_current_level
    end

    def test_restart_instance
      new_stub_request(:post, "./instances/mock_instance/restart")

      @api.restart_instance "mock_instance"
    end

    def test_stop_instance
      new_stub_request(:post, "./instances/mock_instance/stop")
      @api.stop_instance "mock_instance"
    end

    def test_resume_instance
      new_stub_request(:post, "./instances/mock_instance/resume")
      @api.resume_instance "mock_instance"
    end

    def test_show_instance
      new_stub_request(:get, "./instances/mock_instance")
      @api.show_instance "mock_instance"
    end
  end
end
