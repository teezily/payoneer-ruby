require 'spec_helper'
require 'payoneer/v2/response'

describe Payoneer::V2::Request do
  let(:username) { 'username' }
  let(:password) { 'password' }
  let(:basic_auth) { "Basic #{Base64.encode64("#{username}:#{password}") }" }

  let(:response_instance) do
    instance_double(Payoneer::V2::Response, raw_response: response)
  end

  before do
    Payoneer.configure do |config|
      config.partner_username = username
      config.partner_api_password = password
      config.partner_id = 1
    end
    allow(Payoneer::V2::Response).to receive(:new) { response_instance }
  end

  describe '.post' do
    subject(:action) { described_class.post(path, params) }

    let(:path) { 'charges' }
    let(:url) { "#{Payoneer.configuration.api_url_v2}#{path}" }
    let(:params) do
      {
        test: 'test'
      }
    end

    context 'when the response is successful' do
      let(:response) do
        {
          "audit_id"=> 4031733,
          "code"=> 0,
          "description"=> "Success"
        }
      end
      let(:stub) do
        stub_request(:post, url).
          with(
            body: params.to_json,
            headers: {
              'Accept' => 'application/json',
              'Authorization' => basic_auth.chomp,
              'Content-Type' => 'application/json'
            }
        ).
        to_return(status: 200, body: response.to_json)
      end

      before do
        stub
      end

      it 'returns Payoneer::v2::Response' do
        expect(action).to eq(response_instance)
        expect(stub).to have_been_requested
      end
    end
  end

  describe '.get' do
    subject(:action) { described_class.get(path) }

    let(:path) { 'charges' }
    let(:url) { "#{Payoneer.configuration.api_url_v2}#{path}" }

    context 'when the response is successful' do
      let(:response) do
        {
          "audit_id"=> 4031733,
          "code"=> 0,
          "description"=> "Success"
        }
      end
      let(:stub) do
        stub_request(:get, url).
          with(
            headers: {
              'Accept' => 'application/json',
              'Authorization' => basic_auth.chomp,
              'Content-Type' => 'application/json'
            }
        ).
        to_return(status: 200, body: response.to_json)
      end

      before do
        stub
      end

      it 'returns Payoneer::v2::Response' do
        expect(action).to eq(response_instance)
        expect(stub).to have_been_requested
      end
    end
  end
end
