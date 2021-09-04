# Renc

[![Gem Version][gem_version-svg]][gem_version]
[![Build Status][travis-svg]][travis]
[![Downloads][downloads-svg]][gem_version]
[![Inline docs][inch-ci-svg]][inch-ci]
[![Code Climate][codeclimate-svg]][codeclimate]
[![Test Coverage][codeclimate_cov-svg]][codeclimate_cov]

recursive encode for Hash and Array.

<!-- TOC -->

- [1. Installation](#1-installation)
- [2. Usage](#2-usage)
  - [2.1. Basic](#21-basic)
  - [2.2. Nested Hash and Array](#22-nested-hash-and-array)
  - [2.3. Configuration](#23-configuration)
    - [2.3.1. Renc.default_encoding](#231-rencdefault_encoding)
    - [2.3.2. Renc.default_options](#232-rencdefault_options)
- [3. Development](#3-development)
- [4. Contributing](#4-contributing)
- [5. License](#5-license)

<!-- /TOC -->

---

## 1. Installation

Add this line to your application's Gemfile:

```ruby
gem 'renc'
```

And then execute:

```sh
bundle
```

Or install it yourself as:

```sh
gem install renc
```

---

## 2. Usage

### 2.1. Basic

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

### 2.2. Nested Hash and Array

> @ref [./spec/spec_helper.rb](https://github.com/k-ta-yamada/renc/blob/master/spec/spec_helper.rb#L18)

```ruby
nested = {
  a: 'a', # encoding target1
  b: {
    ba: 1,
    bb: [
      'bb0', # encoding target2
      :bb2,
      3
    ]
  }
}
nested.renc == nested # => true

# @ref ./spec/spec_helper.rb#L18
class Hash
  def values_in_nested_hash
    map { |_k, v| v.is_a?(Hash) ? v.values_in_nested_hash : v }
  end
end

encoded_string_values = nested.values_in_nested_hash # => ["a", [1, ["bb0", :bb2, 3]]]
encoded_string_values.flatten! # => ["a", 1, "bb0", :bb2, 3]
encoded_string_values.select! { |v| v.is_a?(String) } # => ["a", "bb0"]
encoded_string_values.all? { |v| v.encoding == Encoding::UTF_8 } # => true
```

### 2.3. Configuration

#### 2.3.1. Renc.default_encoding

```ruby
# default configure encoding is Encoding.default_external
Encoding.default_external # => #<Encoding::UTF-8>
Renc.default_encoding # => #<Encoding::UTF-8>
'test'.renc.encoding  # => #<Encoding::UTF-8>

# if you want to change to ascii
Renc.default_encoding = Encoding::ASCII
'test'.renc.encoding  # => #<Encoding::ASCII>

# change temporaly
'test'.renc(Encoding::ASCII).encoding # => #<Encoding:US-ASCII>
```

#### 2.3.2. Renc.default_options

```ruby
# default configure options is { undef: :replace }
Renc.default_options # => { undef: :replace }
'🐘'.renc  # => '?'

# if you want to change to { undef: nil }
Renc.default_options = { undef: nil }
'🐘'.renc  # => Encoding::UndefinedConversionError: U+1F418 from UTF-8 to US-ASCII

# change temporaly
'🐘'.renc(Encoding::ASCII, undef: nil).encoding # => Encoding::UndefinedConversionError: U+1F418 from UTF-8 to US-ASCII
```

---

## 3. Development

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

---

## 4. Contributing

Bug reports and pull requests are welcome on
GitHub at https://github.com/k-ta-yamada/renc.
This project is intended to be a safe,
welcoming space for collaboration,
and contributors are expected to adhere to the
[Contributor Covenant](https://contributor-covenant.org) code of conduct.

---

## 5. License

The gem is available as open source
under the terms of the [MIT License](https://opensource.org/licenses/MIT).

---

eof

[gem_version]: https://badge.fury.io/rb/renc
[gem_version-svg]: https://badge.fury.io/rb/renc.svg
[travis]: https://app.travis-ci.com/k-ta-yamada/renc
[travis-svg]: https://app.travis-ci.com/k-ta-yamada/renc.svg?branch=master
[codeclimate]: https://codeclimate.com/github/k-ta-yamada/renc
[codeclimate-svg]: https://codeclimate.com/github/k-ta-yamada/renc/badges/gpa.svg
[codeclimate_cov]: https://codeclimate.com/github/k-ta-yamada/renc/coverage
[codeclimate_cov-svg]: https://codeclimate.com/github/k-ta-yamada/renc/badges/coverage.svg
[inch-ci]: https://inch-ci.org/github/k-ta-yamada/renc
[inch-ci-svg]: https://inch-ci.org/github/k-ta-yamada/renc.svg?branch=master
[downloads-svg]: https://ruby-gem-downloads-badge.herokuapp.com/renc?type=total&total_label=&color=brightgreen
