require 'payoneer/v2/response'

module Payoneer
  module V2
    class Request
      def self.post(path, params = {})
        call do
          RestClient.post(
            endpoint(path),
            params.to_json,
            headers
          )
        end
      end

      def self.get(path)
        call do |response|
          RestClient.get(
            endpoint(path),
            headers
          )
        end
      end

      def self.call(&block)
        response = yield

        fail Errors::UnexpectedResponseError.new(response.code, response.body) unless response.code == 200

        Payoneer::V2::Response.new(JSON.parse(response.body))
      end

      def self.basic_auth
        base = [
          Payoneer.configuration.partner_username,
         Payoneer.configuration.partner_api_password
        ].join(':')
        Base64.encode64("Basic#{base}")
      end

      def self.headers
        { content_type: :json, accept: :json, authorization: basic_auth }
      end

      def self.endpoint(path)
        URI.join(Payoneer.configuration.api_url_v2, path).to_s
      end
    end
  end
end
