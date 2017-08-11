# v2.2.0
2017-08-11 JST
- [issue #25](https://github.com/k-ta-yamada/renc/issues/25)
  [add] Add target Class Struct #25
- [issue #26](https://github.com/k-ta-yamada/renc/issues/26)
  [mod] Add error message details #26
- [issue #23](https://github.com/k-ta-yamada/renc/issues/23)
  [clean] Renc::Configuration.default_xxx='s comment is wrong #23

# v2.1.0
- [issue #21](https://github.com/k-ta-yamada/renc/issues/21)
  change class structure; Separate Configuration #21

# v2.0.0
- [issue #10](https://github.com/k-ta-yamada/renc/issues/10)
  Changing default_encoding by os #10
  - change default encoding is `Encoding.default_external`
- [issue #18](https://github.com/k-ta-yamada/renc/issues/18)
  Encoding::UndefinedConversionError #18
  - change `#renc`'s arguments is change.
    #renc(encoding, `obj`) => #renc(encoding, `options`)

# v1.3.1
- [issue #14](https://github.com/k-ta-yamada/renc/issues/14)
  String.include is NoMethodError on Ruby 2.0.0

# v1.3.0
- [issue #7](https://github.com/k-ta-yamada/renc/issues/7)
  configuration default encoding

# v1.2.0
- remove `Renc#enc` method

# v1.1.0
- [issue #4](https://github.com/k-ta-yamada/renc/issues/4)
  #renc for Hash and Array

# v1.0.1
- required Ruby version is change to over 2.0.0.
  - gemspec: `spec.required_ruby_version = '>= 2.0.0'`
    - maybe, be able to run on `version >= 2.0.0`.

# v1.0.0
- change to instance_method from singleton_method.
- renc method is implemented.
- enc method is deprecated.
- required Ruby version is change to over 2.2.4.
  - gemspec: `spec.required_ruby_version = '>= 2.2.4'`
    - maybe, be able to run on `version >= 2.0.0`.
  - Travis CI: 2.2.4, 2.3.0

# v0.2.0
- implement base features.

# v0.1.0
- sorry, this version is dummy.
