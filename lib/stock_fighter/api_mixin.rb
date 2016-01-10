require 'stock_fighter/api_mixin/trading_api'
require 'stock_fighter/api_mixin/game_master_api'

module StockFighter
  module ApiMixin
    def self.included base
      base.extend ClassMethods
    end

    include TradingApi
    include GameMasterApi

    module ClassMethods
      private
      def share_class_http_delegator
        trading_http_delegator = TradingApi.create_partified_module
        game_master_http_delegator = GameMasterApi.create_partified_module

        define_method :trading_http do
          trading_http_delegator
        end
        private :trading_http

        define_method :game_master_http do
          game_master_http_delegator
        end
        private :game_master_http
      end
    end
  end
end
