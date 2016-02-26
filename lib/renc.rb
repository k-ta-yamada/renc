require 'renc/version'

# namespace
module Renc
  def self.enc(obj, encoding = Encoding::UTF_8)
    case obj
    when String then obj.encode(encoding)
    when Hash   then enc_hash(obj, encoding)
    when Array  then enc_array(obj, encoding)
    else             obj
    end
  end

  # private

  def self.enc_hash(obj, encoding)
    obj.each_with_object({}) do |args, h|
      key, val = args
      h[key] = enc(val, encoding)
    end
  end

  def self.enc_array(obj, encoding)
    obj.map { |val| enc(val, encoding) }
  end
end
