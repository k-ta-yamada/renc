require 'codeclimate-test-reporter'
require 'simplecov-console'
formatter = [CodeClimate::TestReporter::Formatter,
             SimpleCov::Formatter::Console,
             SimpleCov::Formatter::HTMLFormatter]
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(formatter)
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'renc'

require 'pry'
require 'pry-doc'
require 'pry-theme'
require 'awesome_print'

RSpec.configure do |config|
  config.example_status_persistence_file_path = './spec/reports/examples.txt'
  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true unless meta.key?(:aggregate_failures)
  end
end

# @ref http://stackoverflow.com/questions/21725218/clear-all-values-in-nested-ruby-hash
class Hash
  def values_in_nested_hash
    map { |_k, v| v.is_a?(Hash) ? v.values_in_nested_hash : v }
  end
end

class Array
  if RUBY_VERSION <= "2.0.0"
    def to_h
      map { |k, v| r = {}; r[k] = v; }
    end
  end
end
