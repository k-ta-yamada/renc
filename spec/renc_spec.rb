require 'spec_helper'

describe Renc do
  include_context 'shared_context'

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

    context 'arguments' do
      context 'encoding' do
        context 'is not an Encoding' do
          subject { proc { ''.renc(1) } }
          it { is_expected.to raise_error(TypeError) }
        end

        context 'is configured' do
          let(:obj) { 'abcdefg' }
          subject { obj.renc(default_encoding_val) }
          it_behaves_like 'return_same_value'
          it_behaves_like 'all_string_val_is_encoded'
        end
      end

      context 'options' do
        context 'are not a Hash' do
          subject { proc { ''.renc(default_encoding_val, 1) } }
          it { is_expected.to raise_error(TypeError) }
        end

        context 'are configured' do
          context ':undef' do
            let(:obj) { '🐘' }

            context ':replace' do
              subject { obj.renc(default_encoding_val, undef: :replace) }
              it { is_expected.to eq('?') }
              it_behaves_like 'all_string_val_is_encoded'
            end

            context 'nil' do
              subject do
                proc { obj.renc(default_encoding_val, default_options_val) }
              end
              it { is_expected.to raise_error(Encoding::UndefinedConversionError) }
            end
          end
        end
      end # context 'options'
    end # context 'arguments'
  end
end
