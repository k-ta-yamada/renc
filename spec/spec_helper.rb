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
# require 'pry-doc' # Failed, saying: ruby/2.5.0 isn't supported by this pry-doc version
# require 'pry-doc'
require 'pry-theme'
require 'awesome_print'

Dir.glob('./spec/support/*') { |file| require file }

RSpec.configure do |config|
  config.example_status_persistence_file_path = './spec/reports/examples.txt'
  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true unless meta.key?(:aggregate_failures)
  end
end

# ######################################################################
# helper methods and constants
# ######################################################################

# @ref http://stackoverflow.com/questions/21725218/clear-all-values-in-nested-ruby-hash
class Hash
  def values_in_nested_hash
    map { |_, v| v.respond_to?(:values_in_nested_hash) ? v.values_in_nested_hash : v }
  end
end

class Array
  def values_in_nested_hash
    map { |v| v.respond_to?(:values_in_nested_hash) ? v.values_in_nested_hash : v }
  end

  if RUBY_VERSION <= '2.0.0'
    def to_h
      map do |k, v|
        r = {}
        r[k] = v
      end
    end
  end
end

class Struct
  def values_in_nested_hash
    map { |v| v.respond_to?(:values_in_nested_hash) ? v.values_in_nested_hash : v }
  end
end

TestStruct = Struct.new(:a, :b, :c)
