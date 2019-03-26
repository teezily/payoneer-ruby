module Payoneer
  module V1
    class Request
      def self.post(method_name, params = {})
        request_params = default_params.merge(mname: method_name).merge(params)

        response = RestClient.post(Payoneer.configuration.api_url_v2, request_params)

        fail Errors::UnexpectedResponseError.new(response.code, response.body) unless response.code == 200

        hash_response = Hash.from_xml(response.body)
        inner_content = hash_response.values.first
        inner_content
      end

      private

      def self.default_params
        {
          p1: Payoneer.configuration.partner_username,
          p2: Payoneer.configuration.partner_api_password,
          p3: Payoneer.configuration.partner_id,
        }
      end
    end
  end
end
