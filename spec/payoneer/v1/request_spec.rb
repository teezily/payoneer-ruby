require 'spec_helper'

describe Payoneer::V1::Request do
  describe '::post' do
    before do
      Payoneer.configure do |config|
        config.partner_username = 'user'
        config.partner_api_password = 'pass'
        config.partner_id = 1
      end
    end

    context 'when the response is unsuccessful' do
      before do
        allow(RestClient).to receive(:post) { double(code: 500, body: '') }
      end

      it 'raises and UnexpectedResponseError if a response code other than 200 is returned' do
        expect{ Payoneer.make_api_request('PayoneerMethod') }.to raise_error(Payoneer::Errors::UnexpectedResponseError)
      end
    end

    context 'when the response is successful' do
      let(:xml_response) {
        <<-XML
        <?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
        <PerformPayoutPayment>
          <Description></Description>
          <PaymentID>1</PaymentID>
          <Status>000</Status>
          <PayoneerID>1</PayoneerID>
        </PerformPayoutPayment>
        XML
      }

      let(:expected_hash_from_xml_response) {
        {
          "Description" => nil,
          "PaymentID" => "1",
          "Status" => "000",
          "PayoneerID" => "1",
        }
      }

      before do
        allow(RestClient).to receive(:post) { double(code: 200, body: xml_response) }
      end

      it 'returns a hash from the Payoneer xml response' do
        expect(Payoneer.make_api_request('PayoneerMethod')).to eq expected_hash_from_xml_response
      end
    end
  end
end
