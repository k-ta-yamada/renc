require 'spec_helper'

describe Renc do
  include described_class
  let(:encoding) { Encoding::Windows_31J }

  context 'benchmark' do
    require 'benchmark'
    let(:size) { 100_000 }
    let(:key) { (1..size).map { |i| "key_#{format('%05d', i)}" } }
    let(:val) { Array.new(size) { 'abc' } }
    let(:obj) { key.zip(val).to_h }

    context 'Hash' do
      subject { Benchmark.realtime { renc(obj, encoding) } }
      it { is_expected.to be < 1 }
    end

    context 'Array' do
      subject { Benchmark.realtime { renc(val, encoding) } }
      it { is_expected.to be < 1 }
    end
  end
end
