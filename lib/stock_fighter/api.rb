module StockFighter
  class Api
    include ApiMixin

    def initialize api_key
      self.set_api_key api_key
    end

    def connect_to_level level_name
      Level.new level_name, self
    end
  end
end
