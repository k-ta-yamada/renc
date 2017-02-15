require 'renc/version'

# recurse encoding for Hash and Array.
# @example
#   require 'renc'
#
#   # or context `main`
#   extend Renc
# @see #renc
module Renc
  # for include #renc method
  TARGET_CLASS = [String, Array, Hash].freeze
  TARGET_CLASS.each { |klass| klass.send(:include, self) }

  # this gem's default configured encoding
  # @see Encoding
  DEFAULT_ENCODING = Encoding::UTF_8

  # this gem's default options for String#encode
  # @see String#encode
  DEFAULT_OPTIONS = { undef: :replace }.freeze

  class << self
    # return @default_encoding
    # @return [Encoding] @default_encoding
    # @see DEFAULT_ENCODING
    def default_encoding
      @default_encoding ||= DEFAULT_ENCODING
    end

    # configure default encoding
    # @example
    #   Renc.default_encoding = 1 # => Renc::ConfigureError
    #   Renc.default_encoding = Encoding::ASCII
    # @param encoding [Encoding]
    def default_encoding=(encoding)
      raise TypeError unless encoding.is_a?(Encoding)
      @default_encoding = encoding
    end

    # return @default_options
    # @return [Encoding] @default_options
    # @see DEFAULT_OPTIONS
    def default_options
      @default_options ||= DEFAULT_OPTIONS
    end

    # configure default options
    # @example
    #   Renc.default_options = 1 # => Renc::ConfigureError
    #   Renc.default_options = { undef: nil }
    # @param options [Hash]
    def default_options=(options)
      raise TypeError unless options.is_a?(Hash)
      @default_options = options
    end
  end

  # recurse encoding for Hash and Array.
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

  # recurse encoding for Hash values of String.
  def renc_hash(obj, encoding, options)
    obj.each_with_object({}) do |(key, val), h|
      h[key] = renc_internal(val, encoding, options)
    end
  end

  # recurse encoding for Array values of String.
  def renc_array(obj, encoding, options)
    obj.map { |val| renc_internal(val, encoding, options) }
  end
end
