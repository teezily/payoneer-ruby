require 'spec_helper'

describe Payoneer::Partner do
  describe '.balance' do
    context 'when success response' do
      let(:success_response) {
        {
          'FeesDue' => '110.45',
          'AccountBalance' => '222.33',
          'Curr' => 'USD'
        }
      }

      it 'returns a response with hash' do
        expect(Payoneer).to receive(:make_api_request).
          with('GetAccountDetails') { success_response }

        expected_response = Payoneer::Response.new('000', success_response)
        actual_response = described_class.balance

        expect(actual_response).to eq(expected_response)
        expect(actual_response.ok?).to be true
      end
    end

    context 'when error response' do
      let(:error_response) {
        {
          'Code' => '006',
          'Error' => 'Internal Error'
        }
      }

      it 'returns a response with error description' do
        expect(Payoneer).to receive(:make_api_request).
          with('GetAccountDetails') { error_response }

        expected_response = Payoneer::Response.new('006', 'Internal Error')
        actual_response = described_class.balance

        expect(actual_response).to eq(expected_response)
        expect(actual_response.ok?).to be false
      end
    end
  end
end
