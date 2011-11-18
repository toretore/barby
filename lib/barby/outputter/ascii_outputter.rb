require 'barby/outputter'

module Barby

  #Outputs an ASCII representation of the barcode. This is mostly useful for printing
  #the barcode directly to the terminal for testing.
  #
  #Registers to_ascii
  class AsciiOutputter < Outputter

    register :to_ascii


    def to_ascii(opts={})
      default_opts = {:height => 10, :xdim => 1, :bar => '#', :space => ' '}
      default_opts.update(:height => 1, :bar => ' X ', :space => '   ') if barcode.two_dimensional?
      opts = default_opts.merge(opts)

      if barcode.two_dimensional?
        booleans.map do |bools|
          line_to_ascii(bools, opts)
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
