require 'barby/outputter'

module Barby

  #Outputs an ASCII representation of the barcode. This is mostly useful for printing
  #the barcode directly to the terminal for testing.
  #
  #Registers to_ascii
  class ASCIIOutputter < Outputter

    register :to_ascii


    def to_ascii(opts={})
      opts = {:height => 10, :xdim => 1, :bar => '#', :space => ' '}.merge(opts)

      if barcode.two_dimensional?
        barcode.encoding.map do |line|
          line_to_ascii(line.split(//).map{|s| s == '1' }, opts)
        end.join("\n")
      else
        line_to_ascii(booleans, opts)
      end
    end


  private

    def line_to_ascii(booleans, opts)
      Array.new(
        opts[:height],
        booleans.map{|b| (b ? opts[:bar] : opts[:space]) * opts[:xdim] }.join
      ).join("\n")
    end


  end

end
