require 'stock_fighter/api_mixin'

module StockFighter
  class Level
    def initialize api_key, level_name = nil, account: nil, venue: nil, stock: nil
      @defaults = {}
      @defaults[:account] = account unless account.nil?
      @defaults[:venue] = venue unless venue.nil?
      @defaults[:stock] = stock unless stock.nil?

      @delegator = Class.new do
        include ApiMixin
      end.new

      @delegator.api_key api_key
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
