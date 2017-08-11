require 'spec_helper'

describe Renc::Configuration do
  include_context 'shared_context'
  include described_class

  describe '.default_encoding' do
    context 'return configured value' do
      before { self.default_encoding = default_encoding_val }
      subject { default_encoding }
      it { is_expected.to eq(default_encoding_val) }
    end
  end

  describe '.default_encoding=' do
    context 'configure none Encoding Class' do
      let(:default_options_val) { 1 }
      subject do
        proc { self.default_encoding = default_options_val }
      end
      it { is_expected.to raise_error(TypeError, err_message_encoding) }
    end
  end

  describe '.default_options' do
    context 'return configured value' do
      before { self.default_options = default_options_val }
      subject { default_options }
      it { is_expected.to eq(default_options_val) }
    end
  end

  describe '.default_options=' do
    context 'configure none Hash Class' do
      let(:default_options_val) { 1 }
      subject do
        proc { self.default_options = default_options_val }
      end
      it { is_expected.to raise_error(TypeError, err_message_options) }
    end
  end
end
