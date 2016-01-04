require 'stock_fighter/api_mixin'

module StockFighter
  class Level
    def initialize level_name, api = nil, api_key: nil, account: nil, venue: nil, stock: nil
      raise "Must provide an API key, or an Api instance." if api.nil? and api_key.nil?

      @name = level_name
      @delegator = api or StockFighter.create_api api_key

      @defaults = {}
      @defaults[:account] = account unless account.nil?
      @defaults[:venue] = venue unless venue.nil?
      @defaults[:stock] = stock unless stock.nil?
    end

    ApiMixin.instance_methods.each do |method|
      required_params = ApiMixin.instance_method(method).parameters.select do |pair|
        pair.first == :req
      end.map(&:last)

      define_method method do |*args, &block|
        prefilled = required_params.map do |param|
          @defaults[param]
        end
        @delegator.send method, *(prefilled + args), &block
      end
    end
  end
end
