require 'spec_helper'

describe Payoneer::Payout do
  describe '.create' do
    let(:params) {
      {
        program_id: '1234',
        payee_id: 'payee123',
        payment_id: 'payment1',
        amount: 5,
        description: 'a payout',
        payment_date: Time.parse('2015-4-30 03:33:44'),
      }
    }

    let(:payoneer_params) {
      {
        p4: '1234',
        p5: 'payment1',
        p6: 'payee123',
        p7: '5.00',
        p8: 'a payout',
        p9: '04/30/2015 03:33:44',
        Currency: 'USD',
      }
    }

    context 'when a payout is successfully created' do
      let(:success_response) {
        {
          "Description" => "Processed Successfully",
          "PaymentID" => "irrelevant_payment_id",
          "Status" => "000",
          "PayoneerID" => "irrelevant_payoneer_id",
        }
      }

      it 'returns a success response' do
        expect(Payoneer).to receive(:make_api_request).with('PerformPayoutPayment', payoneer_params) { success_response }

        expected_response = Payoneer::Response.new('000', 'Processed Successfully')
        actual_response = described_class.create(params)

        expect(actual_response).to eq(expected_response)
      end
    end

    context 'when the payout creation fails' do
      let(:error_response) {
        {
          "Description" => "Insufficient funds",
          "PaymentID" => nil,
          "Status" => "003",
          "PayoneerID" => nil,
        }
      }

      it 'returns an error response' do
        expect(Payoneer).to receive(:make_api_request).with('PerformPayoutPayment', payoneer_params) { error_response }

        expected_response = Payoneer::Response.new('003', 'Insufficient funds')
        actual_response = described_class.create(params)

        expect(actual_response).to eq(expected_response)
      end
    end
  end

  describe '.status' do
    let(:params) {
      {
        payee_id: 'payee123',
        payment_id: 'payment1'
      }
    }

    let(:payoneer_params) {
      {
        p4: 'payee123',
        p5: 'payment1'
      }
    }

    context 'when success response' do
      let(:success_response) {
        {
          'PaymentID' => 'payment1',
          'Result' => '000',
          'Description' => '',
          'PaymentDate' => '04/30/2015 03:33:44',
          'Amount' => '5.00',
          'Status' => 'Payment completed',
          'LoadDate' => '04/30/2015 03:33:44',
          'Curr' => 'USD'
        }
      }

      it 'returns a response with status' do
        expect(Payoneer).to receive(:make_api_request).
          with('GetPaymentStatus', payoneer_params) { success_response }

        expected_response = Payoneer::Response.new('000', 'Payment completed')
        actual_response = described_class.status(params)

        expect(actual_response).to eq(expected_response)
        expect(actual_response.ok?).to be true
      end
    end

    context 'when failed response' do
      context 'when invalid payment_id' do
        let(:error_response) {
          {
            'Result' => 'PE1026',
            'Description' => 'Invalid PaymentID or PayeeID'
          }
        }

        it 'returns an error response with description' do
          expect(Payoneer).to receive(:make_api_request).
            with('GetPaymentStatus', payoneer_params) { error_response }

          expected_response =
            Payoneer::Response.new('PE1026', 'Invalid PaymentID or PayeeID')
          actual_response = described_class.status(params)

          expect(actual_response).to eq(expected_response)
          expect(actual_response.ok?).to be false
        end
      end
    end
  end

  describe '.cancel' do
    let(:payment_id) { 'payment1' }

    let(:payoneer_params) {
      {
        p4: 'payment1'
      }
    }

    context 'when success response' do
      let(:success_response) {
        {
          'PaymentID' => 'payment1',
          'Result' => '000',
          'Amount' => '5.00',
          'Curr' => 'USD',
          'Description' => 'For your wonderful campaign'
        }
      }

      it 'returns a response with hash' do
        expect(Payoneer).to receive(:make_api_request).
          with('CancelPayment', payoneer_params) { success_response }

        expected_response = Payoneer::Response.new('000', success_response)
        actual_response = described_class.cancel(payment_id)

        expect(actual_response).to eq(expected_response)
        expect(actual_response.ok?).to be true
      end
    end

    context 'when error response' do
      let(:error_response) {
        {
          'PaymentID' => 'payment1',
          'Result' => 'PE1026',
          'Description' => 'Invalid paymentId'
        }
      }

      it 'returns an error response with description' do
        expect(Payoneer).to receive(:make_api_request).
          with('CancelPayment', payoneer_params) { error_response }

        expected_response = Payoneer::Response.new('PE1026', 'Invalid paymentId')
        actual_response = described_class.cancel(payment_id)

        expect(actual_response).to eq(expected_response)
        expect(actual_response.ok?).to be false
      end
    end
  end
end
