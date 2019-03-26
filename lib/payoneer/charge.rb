module Payoneer
  class Charge
    def self.create(params)
      Payoneer::V2::Request.post('charges', params)
    end

    def self.cancel(client_reference_id)
      Payoneer::V2::Request.post("charges/#{client_reference_id}/cancel")
    end

    def self.status(client_reference_id)
      Payoneer::V2::Request.get("charges/#{client_reference_id}/status")
    end
  end
end
