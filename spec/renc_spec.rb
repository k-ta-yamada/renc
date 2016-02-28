require 'spec_helper'

describe Renc do
  include described_class

  shared_examples 'example' do |obj|
    context obj.class do
      let(:encoding) { Encoding::Windows_31J }
      subject { renc(obj, encoding) }
      it { is_expected.to eq(obj) }
      it 'all String value is encoded' do
        expected = subject.is_a?(Hash) ? subject.values : [subject]
        expected.flatten!
        expected.select! { |v| v.is_a?(String) }
        expect(expected.map(&:encoding)).to all(eq(encoding))
      end
    end
  end

  describe '#renc' do
    # String
    it_behaves_like 'example', 'abcd'

    # Hash
    it_behaves_like 'example', a: 'a', b: 'b'
    it_behaves_like 'example', a: { aa: { aaa: { aaaa: 'abc' } } }
    it_behaves_like 'example', a: 'a',
                               b: 1,
                               c: { ca: 'abc', cb: 123 },
                               d: [1, 2, 3, 'abc', { da: 123, db: 'abc' }]

    # Array
    it_behaves_like 'example', %w(a b c)
    it_behaves_like 'example', [1, 2, 3, nil, %w(a b c)]

    # Others
    others = [nil, true, false, :symbol, 1, 1.23, (1..3),
              Date.new, DateTime.new, Time.new, /regexp/]
    others.each { |obj| it_behaves_like 'example', obj }
  end
end
