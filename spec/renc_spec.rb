require 'spec_helper'

describe Renc do
  let(:default_encoding) { Encoding::ASCII }
  let(:default_options) { { undef: nil } }

  subject(:base_subject) do
    obj.renc
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
    it { is_expected.to all(eq(Renc.default_encoding)) }
  end

  describe '.default_encoding' do
    context 'is configured' do
      let(:obj) { 'abcdefg' }
      before { described_class.default_encoding = default_encoding }

      it_behaves_like 'return_same_value'
      it_behaves_like 'all_string_val_is_encoded'
    end
  end

  describe '.default_encoding=' do
    subject do
      proc { described_class.default_encoding = default_encoding }
    end

    context 'configure Encoding Class' do
      it { is_expected.not_to raise_error }
    end

    context 'configure none Encoding Class' do
      let(:default_encoding) { 1 }
      it { is_expected.to raise_error(TypeError) }
    end
  end

  describe '.default_options' do
    context 'is configured' do
      let(:obj) { 'abcdefg' }
      before { described_class.default_options = default_options }

      it_behaves_like 'return_same_value'
      it_behaves_like 'all_string_val_is_encoded'
    end
  end

  describe '.default_options=' do
    subject do
      proc { described_class.default_options = default_options }
    end

    context 'configure Encoding Class' do
      it { is_expected.not_to raise_error }
    end

    context 'configure none Hash Class' do
      let(:default_options) { 1 }
      it { is_expected.to raise_error(TypeError) }
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

    describe 'arguments' do
      context 'encoding' do
        context 'is not an Encoding' do
          subject { proc { ''.renc(1) } }
          it { is_expected.to raise_error(TypeError) }
        end
      end

      context 'options' do
        context 'is not a Hash' do
          subject { proc { ''.renc(default_encoding, 1) } }
          it { is_expected.to raise_error(TypeError) }
        end

        context ':undef' do
          let(:obj) { '🐘' }

          context ':replace' do
            subject { obj.renc(default_encoding, undef: :replace) }
            it { is_expected.to eq('?') }
          end

          context 'nil' do
            subject do
              proc { obj.renc(default_encoding, default_options) }
            end
            it { is_expected.to raise_error(Encoding::UndefinedConversionError) }
          end
        end
      end
    end
  end
end
