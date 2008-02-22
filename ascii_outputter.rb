require File.join(File.dirname(__FILE__), 'outputter')

module Barby

  class ASCIIOutputter < Outputter

    register :to_ascii


    def to_ascii(opts={})
      opts = {:height => 10, :xdim => 1}.merge(opts)
      line = booleans.map{|b| (b ? '#' : ' ') * opts[:xdim] }.join
      (0..opts[:height]).map{ line }.join("\n")
    end

  end

end
