require 'httparty'
require 'json'

module StockFighter::ApiMixin
  def self.included base
    http_delegator = Class.new do
      include HTTParty

      base_uri 'https://api.stockfighter.io/ob/api'
      format :json
    end

    base.send :define_method, :http do
      http_delegator
    end
    base.send :private, :http
  end

  def api_key api_key
    http.headers "X-Starfighter-Authorization" => api_key
  end

  def send_heartbeat
    http.get "/heartbeat"
  end

  def send_venue_heartbeat venue
    http.get "/venues/#{venue}/heartbeat"
  end

  def list_stocks venue
    http.get "/venues/#{venue}/stocks"
  end

  def get_orderbook venue, stock
    http.get "/venues/#{venue}/stocks/#{stock}"
  end

  def place_order venue, stock, account:, price:, qty:, direction: "buy", orderType: "limit"
    params = method(__method__).parameters.map(&:last)
    body = params.map { |p| [p, eval(p.to_s)] }.to_h
    http.post "/venues/#{venue}/stocks/#{stock}/orders", body: JSON.dump(body)
  end

  def show_order venue, stock, order
    http.post "/venues/#{venue}/stocks/#{stock}/orders/#{order}"
  end

  def cancel_order venue, stock, order
    http.delete "/venues/#{venue}/stocks/#{stock}/orders/#{order}"
  end

  def get_quote venue, stock
    http.get "/venues/#{venue}/stocks/#{stock}/quote"
  end

  def list_account_orders venue, account
    http.get "/venues/#{venue}/accounts/#{account}/orders"
  end

  def list_account_stock_orders venue, account, stock
    http.get "get/venues/#{venue}/accounts/#{account}/stocks/#{stock}/orders"
  end
end
