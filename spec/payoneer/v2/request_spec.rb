require 'spec_helper'
require 'payoneer/v2/response'

describe Payoneer::V2::Request do
  let(:username) { 'username' }
  let(:password) { 'password' }
  let(:basic_auth) { Base64.encode64("Basic#{username}:#{password}") }

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

  shared_examples 'reponse_unsuccessful' do |http_method|
    context 'when the response is unsuccessful' do
      before do
        allow(RestClient).to receive(http_method) { double(code: 500, body: '') }
      end

      it 'raises and UnexpectedResponseError if a response code other than 200 is returned' do
        expect { action }.to raise_error(Payoneer::Errors::UnexpectedResponseError)
      end
    end
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

    include_examples 'reponse_unsuccessful', :post

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

    include_examples 'reponse_unsuccessful', :get

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
