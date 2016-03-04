require 'spec_helper'

describe Renc do
  include described_class
  let(:encoding) { Encoding::Windows_31J }

  subject(:base_subject) do
    obj.respond_to?(:renc) ? obj.renc(encoding) : renc(encoding, obj)
  end

  shared_examples 'return_same_value' do
    it { is_expected.to eq(obj) }
  end

  shared_examples 'all_string_val_is_encoded' do |size|
    subject(:encoded_vals) do
      expected = case base_subject
                 when Array  then base_subject.flatten
                 when Hash   then base_subject.values_in_nested_hash.flatten
                 else             [base_subject]
                 end
      expected.select! { |v| v.is_a?(String) }
      expected.map!(&:encoding)
    end
    it { expect(encoded_vals.size).to eq(size || 1) }
    it { is_expected.to all(eq(encoding)) }
  end

  describe 'default_encoding' do
    describe '.default_encoding is configured' do
      let(:encoding) { Encoding::ASCII }
      let(:obj) { { a: 'aaa', b: { ba: 'bbb' } } }
      before { described_class.default_encoding = encoding }
      subject { obj.renc }
      it_behaves_like 'return_same_value'
      it_behaves_like 'all_string_val_is_encoded', 2
    end

    describe '.default_encoding=' do
      subject do
        proc { described_class.default_encoding = configure_enc_val }
      end
      context 'configure Encoding Class' do
        let(:configure_enc_val) { encoding }
        it { is_expected.not_to raise_error }
      end
      context 'configure none Encoding Class' do
        let(:configure_enc_val) { 1 }
        it { is_expected.to raise_error(described_class::ConfigureError) }
      end
    end
  end

  describe '#renc' do
    context String do
      let(:obj) { 'abcdefg' }
      it_behaves_like 'return_same_value'
      it_behaves_like 'all_string_val_is_encoded'
    end

    context Array do
      let(:obj) { ['a', 'b', 1, 2, ['aa', 'bb', 11, 22]] }
      it_behaves_like 'return_same_value'
      it_behaves_like 'all_string_val_is_encoded', 4
    end

    context Hash do
      let(:obj) { { a: 'a', b: { ba: 123, bb: 'abc', bc: { bca: 'a' } } } }
      it_behaves_like 'return_same_value'
      it_behaves_like 'all_string_val_is_encoded', 3
    end

    others = [nil, true, false, :symbol, 1, 1.23, (1..3),
              Date.new, DateTime.new, Time.new, /regexp/]
    others.each do |obj|
      context obj.class do
        let(:obj) { obj }
        it_behaves_like 'return_same_value'
        it_behaves_like 'all_string_val_is_encoded', 0
      end
    end
  end
end
