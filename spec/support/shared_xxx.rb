shared_context 'shared_context' do
  let(:default_encoding_val) { Encoding::ASCII }
  let(:default_options_val)  { { undef: nil } }
  let(:err_message_encoding) { 'argument `encoding` is not a Encoding Class' }
  let(:err_message_options)  { 'argument `options` is not a Hash Class' }

  subject(:base_subject) { obj.renc }
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
