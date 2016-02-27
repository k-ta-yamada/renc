require 'renc/version'

# namespace
module Renc
  def renc(obj, encoding = Encoding::UTF_8)
    case obj
    when String then obj.encode(encoding)
    when Hash   then enc_hash(obj, encoding)
    when Array  then enc_array(obj, encoding)
    else             obj
    end
  end

  extend Gem::Deprecate
  alias enc renc
  deprecate :enc, :renc, 2016, 3

  private

  def enc_hash(obj, encoding)
    obj.each_with_object({}) do |args, h|
      key, val = args
      h[key] = renc(val, encoding)
    end
  end

  def enc_array(obj, encoding)
    obj.map { |val| renc(val, encoding) }
  end
end
