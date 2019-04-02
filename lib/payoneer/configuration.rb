require 'uri'

module Payoneer
  class Configuration
    DEVELOPMENT_ENVIRONMENT = 'development'
    PRODUCTION_ENVIRONMENT = 'production'
    DEVELOPMENT_API_URL = 'https://api.sandbox.payoneer.com/Payouts/HttpApi/API.aspx?'
    PRODUCTION_API_URL = 'https://api.payoneer.com/Payouts/HttpApi/API.aspx?'
    DEVELOPMENT_API_URL_V2 = 'https://api.sandbox.payoneer.com/v2/'.freeze
    PRODUCTION_API_URL_V2 = 'https://api.payoneer.com/v2/'.freeze

    attr_accessor :environment,
      :partner_id,
      :partner_username,
      :partner_api_password,
      :auto_approve_sandbox_accounts,
      :debug

    def initialize
      @environment = DEVELOPMENT_ENVIRONMENT
      @auto_approve_sandbox_accounts = false
    end

    def production?
      environment == PRODUCTION_ENVIRONMENT
    end

    def api_url
      production? ? PRODUCTION_API_URL : DEVELOPMENT_API_URL
    end

    def api_url_v2
      url = if production?
        PRODUCTION_API_URL_V2
      else
        DEVELOPMENT_API_URL_V2
      end
      URI.join(url, 'programs/', "#{partner_id}/").to_s
    end

    def auto_approve_sandbox_accounts?
      !production? && auto_approve_sandbox_accounts
    end

    def validate!
      fail Errors::ConfigurationError unless partner_id && partner_username && partner_api_password
    end
  end
end
