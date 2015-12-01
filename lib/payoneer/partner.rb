module Payoneer
  class Partner
    ACCOUNT_DETAILS_API_METHOD_NAME = 'GetAccountDetails'

    def self.balance
      response = Payoneer.make_api_request(ACCOUNT_DETAILS_API_METHOD_NAME)

      if success?(response)
        Response.new_ok_response(response)
      else
        Response.new(response['Code'], response['Error'])
      end
    end

    private

    def self.success?(response)
      !response.has_key?('Code')
    end
  end
end
