require 'faraday'
require 'payoneer/errors/unexpected_response_error'

module Payoneer
  class HttpMiddleware < Faraday::Middleware
    def call(request_env)
      @app.call(request_env).on_complete do |response|
        unless response[:status].to_i == 200
          raise Payoneer::Errors::UnexpectedResponseError.new(response[:status], response[:body])
        end
      end
    end
  end
end
