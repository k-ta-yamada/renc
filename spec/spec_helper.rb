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

# @ref http://stackoverflow.com/questions/21725218/clear-all-values-in-nested-ruby-hash
class Hash
  def values_in_nested_hash
    map { |_k, v| v.is_a?(Hash) ? v.values_in_nested_hash : v }
  end
end
