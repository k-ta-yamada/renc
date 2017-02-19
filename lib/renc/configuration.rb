module Renc
  # namespace
  module Configuration
    # this gem's default configured encoding
    # @see Encoding.default_external
    DEFAULT_ENCODING = Encoding.default_external

    # this gem's default options for String#encode
    # @see String#encode
    DEFAULT_OPTIONS = { undef: :replace }.freeze

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
end
