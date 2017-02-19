require 'renc/version'
require 'renc/configuration'

# recursive encode for Hash and Array.
# @example
#   require 'renc'
#
#   # or context `main`
#   extend Renc
# @see #renc
module Renc
  extend Configuration

  # for include #renc method
  TARGET_CLASS = [String, Array, Hash].freeze
  TARGET_CLASS.each { |klass| klass.send(:include, self) }

  # recursive encode for Hash and Array.
  # @example
  #   # for example
  #   default_src_encoding # => #<Encoding:UTF-8>
  #
  #   # Hash values
  #   result = { a: 'a', b: 'b', c: 'c' }.renc(Encoding::ASCII)
  #   result # => { a: 'a', b: 'b', c: 'c' }
  #   result.values.map(&:encoding).all? { Encoding::ASCII } # => true
  #
  #   # Array values
  #   result = %w(a b c).renc(Encoding::ASCII)
  #   result # => ['a', 'b', 'c']
  #   result.map(&:encoding).all? { Encoding::ASCII } # => true
  #
  #   # with configure default_encoding
  #   Renc.default_encoding = Encoding::ASCII
  #   result = 'hello'.renc
  #   result # => 'hello'
  #   result.encoding # => Encoding::ASCII
  # @param encoding [Encoding]
  # @param options [Hash]
  # @return [Object]
  # @see .default_encoding
  # @see .default_options
  def renc(encoding = Renc.default_encoding, options = Renc.default_options)
    raise TypeError unless encoding.is_a?(Encoding)
    raise TypeError unless options.is_a?(Hash)

    renc_internal(self, encoding, options)
  end

  private

  def renc_internal(obj, encoding, options)
    case obj
    when Hash   then renc_hash(obj, encoding, options)
    when Array  then renc_array(obj, encoding, options)
    when String then obj.encode(encoding, options)
    else obj
    end
  end

  # recursive encode for Hash values of String.
  def renc_hash(obj, encoding, options)
    obj.each_with_object({}) do |(key, val), h|
      h[key] = renc_internal(val, encoding, options)
    end
  end

  # recursive encode for Array values of String.
  def renc_array(obj, encoding, options)
    obj.map { |val| renc_internal(val, encoding, options) }
  end
end
