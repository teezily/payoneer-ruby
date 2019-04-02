require 'spec_helper'

describe Payoneer::V2::Response do
  let(:service) { described_class.new(response) }

  let(:response) do
    {
      'test' => 'test',
      'description' => 'desription'
    }
  end

  describe '#raw_response' do
    subject { service.raw_response }

    it { is_expected.to eq(response) }
  end

  describe '#success?' do
    subject { service.success? }

    it { is_expected.to be_falsy }

    context 'successful' do
      let(:response) do
        {
          'test' => 'test',
          'description' => 'SucCess'
        }
      end

      it { is_expected.to be_truthy }
    end
  end
end
