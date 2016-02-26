require 'spec_helper'

describe Renc do
  it 'has a version number' do
    expect(Renc::VERSION).not_to be nil
  end

  describe '.enc' do
    context 'Hash value is String' do
      xit 'encode value' do
        encoded = described_class.enc({ a: 1, b: 'abc'}, Encoding::ASCII)
        expect(encoded[:b].encoding).to eq(Encoding::ASCII)
      end
    end
  end
end
