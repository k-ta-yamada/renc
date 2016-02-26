require "renc/version"

module Renc
  def self.enc(val, encoding = Encoding::UTF_8)
    case val
    when :dummy
      # do
    else
      val
    end
  end
end
