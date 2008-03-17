require 'barby/outputter'

module Barby

  #Outputs an ASCII representation of the barcode. This is mostly useful for printing
  #the barcode directly to the terminal for testing.
  class ASCIIOutputter < Outputter

    register :to_ascii


    def to_ascii(opts={})
      opts = {:height => 10, :xdim => 1, :bar => '#', :space => ' '}.merge(opts)
      Array.new(
        opts[:height],
        booleans.map{|b| (b ? opts[:bar] : opts[:space]) * opts[:xdim] }.join
      ).join("\n")
    end

  end

end
