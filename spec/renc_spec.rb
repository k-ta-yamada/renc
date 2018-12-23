require 'spec_helper'

describe Renc do
  include_context 'shared_context'

  describe '#renc' do
    context String do
      let(:obj) { 'abcdefg' }
      it_behaves_like 'return_same_value'
      it_behaves_like 'all_string_val_is_encoded'
    end

    context Hash do
      let(:obj) { { a: 'a', b: 123, c: :c } }
      it_behaves_like 'return_same_value'
      it_behaves_like 'return_same_class'
      it_behaves_like 'all_string_val_is_encoded', 1
    end

    context Array do
      let(:obj) { %w[a b c] }
      it_behaves_like 'return_same_value'
      it_behaves_like 'return_same_class'
      it_behaves_like 'all_string_val_is_encoded', 3
    end

    context Struct do
      let(:obj) { TestStruct.new('a', 'b', 'c') }
      it_behaves_like 'return_same_value'
      it_behaves_like 'return_same_class'
      it_behaves_like 'all_string_val_is_encoded', 3
    end

    context 'nested_object' do
      let(:obj) do
        {
          a: 'a',
          b: {
            ba: 123,
            bb: 'bb',
            bc: {
              bca: 'bca',
              bcb: ['bcb', { bcba: 'bcba', bcbb: 123 }]
            }
          },
          c: TestStruct.new('ca', [123, { cb: 'cb' }], cc: 'cc')
        }
      end
      it_behaves_like 'return_same_value'
      it_behaves_like 'return_same_class'
      it_behaves_like 'all_string_val_is_encoded', 8
    end

    context 'arguments' do
      context 'encoding' do
        context 'is not an Encoding' do
          subject { proc { ''.renc(1) } }
          it { is_expected.to raise_error(TypeError, err_message_encoding) }
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
          it { is_expected.to raise_error(TypeError, err_message_options) }
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
      end
    end
  end
end
