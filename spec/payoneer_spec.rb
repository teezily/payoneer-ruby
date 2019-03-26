require 'spec_helper'

describe Payoneer do
  it 'has a version number' do
    expect(Payoneer::VERSION).not_to be nil
  end

  describe '.make_api_request' do
    subject(:action) { Payoneer.make_api_request(method_name, params) }

    let(:method_name) { 'method_name' }
    let(:params) do
      {
        params1: 'params1'
      }
    end
    let(:http_method) { :post }

    before do
      Payoneer.configure do |config|
        config.partner_username = 'user'
        config.partner_api_password = 'pass'
        config.partner_id = 1
      end
    end

    it 'calls post on Payoneer::V1::Request' do
      expect(Payoneer::V1::Request).to receive(http_method).with(method_name, params)
      action
    end

    context 'v2 force in arg' do
      subject(:action) { Payoneer.make_api_request(method_name, params, http_method, 2) }

      it 'calls post on Payoneer::V2::Request' do
        expect(Payoneer::V2::Request).to receive(http_method).with(method_name, params)
        action
      end

      context 'get http_method without params' do
        subject(:action) { Payoneer.make_api_request(method_name, nil, http_method, 2) }

        let(:http_method) { :get }

        it 'calls get on Payoneer::V2::Request' do
          expect(Payoneer::V2::Request).to receive(http_method).with(method_name)
          action
        end
      end
    end

    context 'when Payoneer is not configured' do
      it 'raises a ConfigurationError if not all config values are set' do
        Payoneer.configure do |config|
          config.partner_username = nil
        end

        expect{ Payoneer.make_api_request('method') }.to raise_error(Payoneer::Errors::ConfigurationError)
      end
    end
  end

  describe '.configure' do
    before do
      Payoneer.configure do |config|
        config.partner_username = 'the_user_name'
      end
    end

    it 'yields the Payoneer configuration for a block to instantiate' do
      expect(Payoneer.configuration.partner_username).to eq 'the_user_name'
    end

    it 'yields the same configuration for multiple calls' do
      Payoneer.configure do |config|
        config.partner_id = 3
      end

      expect(Payoneer.configuration.partner_username).to eq 'the_user_name'
      expect(Payoneer.configuration.partner_id).to eq 3
    end
  end
end
