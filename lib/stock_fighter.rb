require "stock_fighter/version"
require "stock_fighter/level"
require "stock_fighter/api"

module StockFighter
  def self.create_api api_key
    Api.new api_key
  end
end
