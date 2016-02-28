require 'renc/version'

# recurse encoding for Hash and Array.
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
module Renc
  # include #renc method
  [String, Hash, Array].each { |klass| klass.include self }

  # recurse encoding for Hash and Array.
  # @param obj [Object]
  # @param encoding [Encoding]
  # @return [Object]
  def renc(encoding = Encoding::UTF_8, obj = self)
    # binding.pry
    case obj
    when String then obj.encode(encoding)
    when Hash   then renc_hash(obj, encoding)
    when Array  then renc_array(obj, encoding)
    else             obj
    end
  end

  # @see #renc
  alias enc renc
  extend Gem::Deprecate
  deprecate :enc, :renc, 2016, 3

  private

  # recurse encoding for Hash values of String.
  def renc_hash(obj, encoding)
    obj.each_with_object({}) do |args, h|
      key, val = args
      h[key] = renc(encoding, val)
      # h[key] = val.renc(encoding)
    end
  end

  # recurse encoding for Array values of String.
  def renc_array(obj, encoding)
    obj.map { |val| renc(encoding, val) }
  end
end
