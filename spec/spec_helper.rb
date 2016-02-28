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
