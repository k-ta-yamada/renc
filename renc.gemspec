# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'renc/version'

Gem::Specification.new do |spec|
  spec.name          = 'renc'
  spec.version       = Renc::VERSION
  spec.authors       = ['k-ta-yamada']
  spec.email         = ['key.luvless@gmail.com']

  spec.required_ruby_version = '>= 2.0.0'

  spec.summary       = 'recurse encoding for Hash and Array.'
  spec.description   = 'recurse encoding for Hash and Array.'
  spec.homepage      = 'https://github.com/k-ta-yamada/renc'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'pry-theme'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'awesome_print'
end
