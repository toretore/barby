require 'dmtx' # gem install dmtx
require 'barby/barcode'

module Barby


  #Uses the dmtx library (gem install dmtx) to encode DataMatrix barcodes
  class DataMatrix < Barcode2D

    attr_reader :data, :encoding, :width, :height


    def initialize(data, encoding: nil, width: nil, height: nil)
      self.data = data
      @encoding = encoding
      @width = width
      @height = height
    end

    def data=(data)
      @data = data
      @encoder = nil
    end

    def encoder
      @encoder ||= ::Dmtx::DataMatrix.new(data, encoding: @encoding, width: @width, height: @height)
    end


    # Converts the barcode to an array of lines where 0 is white and 1 is black.
    #
    # @example
    #   code = Barby::DataMatrix.new('humbaba')
    #   code.encoding
    #   # => [
    #   # "10101010101010",
    #   # "10111010000001",
    #   # "11100101101100",
    #   # "11101001110001",
    #   # "11010101111110",
    #   # "11100101100001",
    #   # "11011001011110",
    #   # "10011011010011",
    #   # "11011010000100",
    #   # "10101100101001",
    #   # "11011100001100",
    #   # "10101110110111",
    #   # "11000001010100",
    #   # "11111111111111",
    #   # ]
    #
    # @return [String]
    def encoding
      width = encoder.width
      height = encoder.height

      height.times.map { |y| width.times.map { |x| bit?(x, y) ? '1' : '0' }.join }
    end


    # NOTE: this method is not exposed via the gem so using send ahead of opening a PR to hopefully support:
    #
    # https://github.com/mtgrosser/dmtx/blob/master/lib/dmtx/data_matrix.rb#L133-L135
    #
    # @param x [Integer] x-coordinate
    # @param y [Integer] y-coordinate
    # @return [Boolean]
    def bit?(x, y)
      encoder.send(:bit?, x, y)
    end


    # The data being encoded.
    #
    # @return [String]
    def to_s
      data
    end


  end

end
