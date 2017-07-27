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
    raise TypeError, ERR_MESSAGE_ENCODING unless encoding.is_a?(Encoding)
    raise TypeError, ERR_MESSAGE_OPTIONS unless options.is_a?(Hash)

    @encoding = encoding
    @options  = options

    _renc(self)
  end

  private

  def _renc(obj)
    case obj
    when Hash   then _hash(obj)
    when Array  then _array(obj)
    when String then obj.encode(@encoding, @options)
    else obj
    end
  end

  # recursive encode for Hash values of String.
  def _hash(obj)
    obj.each_with_object({}) { |(k, v), h| h[k] = _renc(v) }
  end

  # recursive encode for Array values of String.
  def _array(obj)
    obj.map { |v| _renc(v) }
  end
end
