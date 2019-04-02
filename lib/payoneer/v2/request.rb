require 'payoneer/v2/response'
require 'faraday'
require 'faraday_middleware'
require 'payoneer/v2/http_middleware'

module Payoneer
  module V2
    class Request
      def self.post(path, params = {})
        call(:post, path, params)
      end

      def self.get(path)
        call(:get, path)
      end

      def self.call(method, path, params = {})
        response = client.send(method) do |r|
          r.url(path)
          r.body = params.to_json if method == :post
        end
        Payoneer::V2::Response.new(response.body)
      end

      private

      def self.client
        Faraday.new(url: Payoneer.configuration.api_url_v2) do |f|
          f.request :multipart
          f.headers['Content-Type'] = 'application/json'
          f.headers['Accept'] = 'application/json'
          f.headers['Authorization'] = basic_auth
          f.use Payoneer::HttpMiddleware
          f.use FaradayMiddleware::ParseJson
          f.request :url_encoded
          f.response :logger, ::Logger.new(STDOUT), bodies: true if Payoneer.configuration.debug
          f.adapter :excon
        end
      end

      def self.basic_auth
        base = [
          Payoneer.configuration.partner_username,
         Payoneer.configuration.partner_api_password
        ].join(':')
        "Basic #{Base64.strict_encode64(base)}"
      end
    end
  end
end
