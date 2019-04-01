#Payoneer Ruby bindings
#API spec at https://github.com/teespring/payoneer-ruby
require 'rest-client'
require 'active_support'
require 'active_support/core_ext'

# Version
require 'payoneer/version'

# Configuration
require 'payoneer/configuration'

# Resources
require 'payoneer/v1/request'
require 'payoneer/v2/request'
require 'payoneer/response'
require 'payoneer/v2/response'
require 'payoneer/system'
require 'payoneer/payee'
require 'payoneer/payout'
require 'payoneer/partner'
require 'payoneer/charge'

# Errors
require 'payoneer/errors/unexpected_response_error'
require 'payoneer/errors/configuration_error'

module Payoneer
  def self.configure
    yield(configuration)
  end

  def self.make_api_request(method_name, params = nil, http_method = :post, version = 1)
    configuration.validate!

    "Payoneer::V#{version}::Request".constantize.send(http_method, *[method_name, params].compact)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end
end
