require File.join(File.dirname(__FILE__), 'outputter')

module Barby

  class ASCIIOutputter < Outputter

    register :to_ascii


    def to_ascii(opts={})
      opts = {:height => 10, :xdim => 1}.merge(opts)
      Array.new(
        opts[:height],
        booleans.map{|b| (b ? '#' : ' ') * opts[:xdim] }.join
      ).join("\n")
    end

  end

end
