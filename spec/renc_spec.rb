require 'spec_helper'

describe Renc do
  it 'has a version number' do
    expect(Renc::VERSION).not_to be nil
  end

  let(:encoding) { Encoding::ASCII }

  describe '.enc' do
    context 'String value' do
      it 'encode value' do
        encoded = described_class.enc('abc', encoding)
        expect(encoded.encoding).to eq(encoding)
      end
    end

    context 'Hash value is String' do
      it 'encode value' do
        encoded = described_class.enc({ a: 1, b: 'abc' }, encoding)
        expect(encoded[:a]).to eq(1)
        expect(encoded[:b].encoding).to eq(encoding)
      end
    end

    context 'Array value is String' do
      it 'encode value' do
        encoded = described_class.enc([1, 2, 3, :a, 'b'], encoding)
        expect(encoded.first).to eq(1)
        expect(encoded.last.encoding).to eq(encoding)
      end
    end
  end
end
