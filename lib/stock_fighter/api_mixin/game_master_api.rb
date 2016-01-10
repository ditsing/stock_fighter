require 'httparty'
require 'json'

module StockFighter::ApiMixin
  module GameMasterApi
    def list_levels
      raise NotImplementedError

      game_master_http.get '/levels'
    end

    def start_current_level
      game_master_http.post '/levels/first_steps'
    end

    def restart_instance instance
      game_master_http.post "/instances/#{instance}/restart"
    end

    def stop_instance instance
      game_master_http.post "/instances/#{instance}/stop"
    end

    def resume_instance instance
      game_master_http.post "/instances/#{instance}/resume"
    end

    def show_instance instance
      game_master_http.get "/instances/#{instance}"
    end

    private
    def game_master_http
      @game_master_http_delegator ||= GameMasterApi.create_partified_module
    end

    def self.create_partified_module
      Module.new do
        include HTTParty

        base_uri 'https://www.stockfighter.io/gm'
        format :json
      end
    end
  end
end
