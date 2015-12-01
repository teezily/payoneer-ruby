module Payoneer
  class Payout
    CREATE_PAYOUT_API_METHOD_NAME = 'PerformPayoutPayment'
    GET_PAYMENT_STATUS_API_METHOD_NAME = 'GetPaymentStatus'

    def self.create(program_id:, payment_id:, payee_id:, amount:, description:, payment_date: Time.now, currency: 'USD')
      payoneer_params = {
        p4: program_id,
        p5: payment_id,
        p6: payee_id,
        p7: '%.2f' % amount,
        p8: description,
        p9: payment_date.strftime('%m/%d/%Y %H:%M:%S'),
        Currency: currency,
      }

      response = Payoneer.make_api_request(CREATE_PAYOUT_API_METHOD_NAME, payoneer_params)

      Response.new(response['Status'], response['Description'])
    end

    def self.status(payee_id:, payment_id:)
      payoneer_params = {
        p4: payee_id,
        p5: payment_id
      }

      response = Payoneer.make_api_request(GET_PAYMENT_STATUS_API_METHOD_NAME,
                                           payoneer_params)

      if success?(response)
        Response.new(response['Result'], response['Status'])
      else
        Response.new(response['Result'], response['Description'])
      end
    end

    private

    def self.success?(response)
      response['Result'] == '000'
    end
  end
end
