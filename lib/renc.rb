require 'renc/version'

# recurse encoding for Hash and Array.
module Renc
  # raise unless encoding.is_a?(Encoding)
  class ConfigureError < StandardError; end

  # this gem's default configured encoding
  DEFAULT_ENCODING = Encoding::UTF_8

  # for include #renc method
  TARGET_CLASS = [String, Array, Hash].freeze
  TARGET_CLASS.each { |klass| klass.include self }


  class << self
    # return @default_encoding
    # @return [Encoding] @default_encoding
    # @see DEFAULT_ENCODING
    def default_encoding
      @default_encoding ||= DEFAULT_ENCODING
    end

    # configure default encoding
    # @param encoding [Encoding]
    # @example
    #   Renc.default_encoding = 1 # => Renc::ConfigureError
    #   Renc.default_encoding = Encoding::ASCII
    def default_encoding=(encoding)
      raise ConfigureError,
            'Encoding class only allow' unless encoding.is_a?(Encoding)
      @default_encoding = encoding
    end
  end

  # recurse encoding for Hash and Array.
  # @param encoding [Encoding]
  # @param obj [Object]
  # @return [Object]
  # @example
  #   default_src_encoding # => #<Encoding:UTF-8>
  #
  #   # Hash values
  #   result = { a: 'a', b: 'b', c: 'c' }.renc(Encoding::Windows_31J)
  #   result # => { a: 'a', b: 'b', c: 'c' }
  #   result.values.map(&:encoding).all? { Encoding::Windows_31J } # => true
  #
  #   # Array values
  #   result = %w(a b c).renc(Encoding::Windows_31J)
  #   result # => ['a', 'b', 'c']
  #   result.map(&:encoding).all? { Encoding::Windows_31J } # => true
  #
  #   # if u define Kernel.renc method.
  #   Kernel.include Renc
  #   Object.include Kernel
  #   # or context `main`
  #   extend Renc
  def renc(encoding = Renc.default_encoding, obj = self)
    case obj
    when String then obj.encode(encoding)
    when Array  then renc_array(obj, encoding)
    when Hash   then renc_hash(obj, encoding)
    else             obj
    end
  end

  private

  # recurse encoding for Hash values of String.
  def renc_hash(obj, encoding)
    obj.each_with_object({}) do |args, h|
      key, val = args
      h[key] = renc(encoding, val)
    end
  end

  # recurse encoding for Array values of String.
  def renc_array(obj, encoding)
    obj.map { |val| renc(encoding, val) }
  end
end
