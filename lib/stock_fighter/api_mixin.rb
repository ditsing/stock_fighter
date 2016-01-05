require 'httparty'
require 'json'

# TODO: better testing.
module StockFighter
  module ApiMixin
    def self.included base
      base.extend ClassMethods
    end

    def set_api_key api_key
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

    def place_order venue, stock, account, price:, qty:, direction: "buy", order_type: "limit"
      params = method(__method__).parameters.map(&:last)
      body = params.map { |p| [p, eval(p.to_s)] }.to_h

      body[:orderType] = body.delete(:order_type)

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

    private
    def http
      # TODO: how do we create module specific vars?
      @http_delegator ||= ApiMixin.create_partified_module
    end

    def self.create_partified_module
      Module.new do
        include HTTParty

        base_uri 'https://api.stockfighter.io/ob/api'
        format :json
      end
    end

    module ClassMethods
      private
      def share_http_delegator
        http_delegator = ApiMixin.create_partified_module
        define_method :http do
          http_delegator
        end
        private :http
      end
    end
  end
end
