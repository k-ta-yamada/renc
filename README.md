[![Gem Version][gem_version-svg]][gem_version]
[![Build Status][travis-svg]][travis]
[![Code Climate][codeclimate-svg]][codeclimate]
[![Test Coverage][codeclimate_cov-svg]][codeclimate_cov]
[![Inline docs][inch-ci-svg]][inch-ci]

# Renc

recurse encoding for Hash and Array.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'renc'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install renc

## Usage

### Basic

```ruby
require 'renc'

# String
str_ascii = 'hello renc!'.encode(Encoding::ASCII)
str_ascii.encoding          # => #<Encoding::US-ASCII>
str_ascii.renc.encoding     # => #<Encoding::UTF-8>
str_ascii == str_ascii.renc # => true

# Array
array_val = [str_ascii]
array_val.first.encoding      # => #<Encoding::US-ASCII>
array_val.renc.first.encoding # => #<Encoding::UTF-8>
array_val.renc == array_val   # => ture

# Hash
hash_val = { a: str_ascii }
hash_val[:a].encoding      # => #<Encoding::US-ASCII>
hash_val.renc[:a].encoding # => #<Encoding::UTF-8>
hash_val.renc == hash_val  # => true

```

### Nested Hash, Array, and others
> @ref [./spec/spec_helper.rb](https://github.com/k-ta-yamada/renc/blob/feature/issue7/spec/spec_helper.rb#L18)

```ruby
# @ref ./spec/spec_helper.rb#L18
class Hash
  def values_in_nested_hash
    map { |_k, v| v.is_a?(Hash) ? v.values_in_nested_hash : v }
  end
end

nested = { a: 'a',           # encoding target1
           b: { ba: 1,
                bb: [
                      'bb0', # encoding target2
                      :bb2,
                      3
                    ]
              }
         }
nested.renc == nested # => true

encoded_string_values = nested.values_in_nested_hash
encoded_string_values.flatten!
encoded_string_values.select! { |v| v.is_a?(String) } # => ["a", "bb0"]
encoded_string_values.all? { |v| v.encoding == Encoding::UTF_8 } # => true
```

### Configuration

```ruby
# default configure encoding is utf-8
Renc.default_encoding # => #<Encoding::UTF-8>
'test'.renc.encoding  # => #<Encoding::UTF-8>

# if you want to change to sjis
Renc.default_encoding = Encoding::Windows_31J
'test'.renc.encoding  # => #<Encoding::Windows-31J>

# change temporaly
'test'.renc(Encoding::ASCII).encoding # => #<Encoding:US-ASCII>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt
that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release`,
which will create a git tag for the version,
push git commits and tags,
and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on
GitHub at https://github.com/k-ta-yamada/renc.
This project is intended to be a safe,
welcoming space for collaboration,
and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source
under the terms of the [MIT License](http://opensource.org/licenses/MIT).



[gem_version]: http://badge.fury.io/rb/renc
[gem_version-svg]: https://badge.fury.io/rb/renc.svg
[travis]: https://travis-ci.org/k-ta-yamada/renc
[travis-svg]: https://travis-ci.org/k-ta-yamada/renc.svg
[codeclimate]: https://codeclimate.com/github/k-ta-yamada/renc
[codeclimate-svg]: https://codeclimate.com/github/k-ta-yamada/renc/badges/gpa.svg
[codeclimate_cov]: https://codeclimate.com/github/k-ta-yamada/renc/coverage
[codeclimate_cov-svg]: https://codeclimate.com/github/k-ta-yamada/renc/badges/coverage.svg
[inch-ci]: http://inch-ci.org/github/k-ta-yamada/renc
[inch-ci-svg]: http://inch-ci.org/github/k-ta-yamada/renc.svg?branch=master
