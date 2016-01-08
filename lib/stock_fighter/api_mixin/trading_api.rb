require 'httparty'
require 'json'

module StockFighter::ApiMixin
  module TradingApi
    def set_api_key api_key
      trading_http.headers "X-Starfighter-Authorization" => api_key
    end

    def send_heartbeat
      trading_http.get "/heartbeat"
    end

    def send_venue_heartbeat venue
      trading_http.get "/venues/#{venue}/heartbeat"
    end

    def list_stocks venue
      trading_http.get "/venues/#{venue}/stocks"
    end

    def get_orderbook venue, stock
      trading_http.get "/venues/#{venue}/stocks/#{stock}"
    end

    def place_order venue, stock, account, price:, qty:, direction: "buy", order_type: "limit"
      params = method(__method__).parameters.map(&:last)
      body = params.map { |p| [p, eval(p.to_s)] }.to_h

      body[:orderType] = body.delete(:order_type)

      trading_http.post "/venues/#{venue}/stocks/#{stock}/orders", body: JSON.dump(body)
    end

    def show_order venue, stock, order
      trading_http.post "/venues/#{venue}/stocks/#{stock}/orders/#{order}"
    end

    def cancel_order venue, stock, order
      trading_http.delete "/venues/#{venue}/stocks/#{stock}/orders/#{order}"
    end

    def get_quote venue, stock
      trading_http.get "/venues/#{venue}/stocks/#{stock}/quote"
    end

    def list_account_orders venue, account
      trading_http.get "/venues/#{venue}/accounts/#{account}/orders"
    end

    def list_account_stock_orders venue, account, stock
      trading_http.get "/get/venues/#{venue}/accounts/#{account}/stocks/#{stock}/orders"
    end

    private
    def trading_http
      # TODO: how do we create module specific vars?
      @trading_http_delegator ||= TradingApi.create_partified_module
    end

    def self.create_partified_module
      Module.new do
        include HTTParty

        base_uri 'https://api.stockfighter.io/ob/api'
        format :json
      end
    end
  end
end
