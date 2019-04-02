require 'spec_helper'

describe Payoneer::Charge do
  before do
    Payoneer.configure do |config|
      config.partner_username = 'username'
      config.partner_api_password = 'password'
      config.partner_id = 1
    end
  end

  describe '::create' do
    subject(:action) { described_class.create(params) }

    let(:params) do
      {
        test: 'test'
      }
    end
    let(:url) { "#{Payoneer.configuration.api_url_v2}charges" }
    let(:stub) do
      stub_request(:post, url).
        with(
          body: params.to_json,
      ).
      and_return(status: 200, body: {}.to_json)
    end

    before { stub }

    it 'request' do
      action
      expect(stub).to have_been_requested
    end
  end

  describe '::cancel' do
    subject(:action) { described_class.cancel(reference_id) }

    let(:reference_id) { 1234 }
    let(:url) { "#{Payoneer.configuration.api_url_v2}charges/#{reference_id}/cancel" }
    let(:stub) do
      stub_request(:post, url).
        with(
          body: {}.to_s
      ).
      and_return(status: 200, body: {}.to_json)
    end

    before { stub }

    it 'request' do
      action
      expect(stub).to have_been_requested
    end
  end

  describe '::status' do
    subject(:action) { described_class.status(reference_id) }

    let(:reference_id) { 1234 }
    let(:url) { "#{Payoneer.configuration.api_url_v2}charges/#{reference_id}/status" }
    let(:stub) do
      stub_request(:get, url).
        and_return(status: 200, body: {}.to_json)
    end

    before { stub }

    it 'request' do
      action
      expect(stub).to have_been_requested
    end
  end
end
