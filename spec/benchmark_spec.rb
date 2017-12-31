require 'spec_helper'
require 'benchmark'

describe Renc do
  include described_class

  let(:size) { 10_000 }
  let(:key) { (1..size).map { |i| "key_#{format('%06d', i)}" } }
  let(:hash) { key.zip(array).to_h }
  let(:array) { Array.new(size) { 'abc' } }
  let(:struct) { Struct.new(*key.map(&:to_sym)).new(*array) }

  shared_examples 'less_than' do |performance_expectation, type|
    let(:target_object) do
      { in_hash:   hash,
        in_array:  array,
        in_struct: struct }[type]
    end

    # Evaluate the target object because it takes time to generate
    before { target_object.size }
    subject { Benchmark.realtime { target_object.renc } }
    it { is_expected.to be < performance_expectation }
  end

  context 'benchmark' do
    context 'Hash' do
      it_behaves_like 'less_than', 0.5, :in_hash
    end

    context 'Array' do
      it_behaves_like 'less_than', 0.5, :in_array
    end

    context 'Struct' do
      it_behaves_like 'less_than', 0.5, :in_struct
    end
  end
end
