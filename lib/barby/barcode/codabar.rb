require "barby/barcode"

module Barby
  # https://en.wikipedia.org/wiki/Codabar
  class Codabar < Barcode1D
    BLACK_NARROW_WIDTH = 1
    WHITE_NARROW_WIDTH = 2
    WIDE_WIDTH_RATE = 3
    SPACING = 5 # must be equal to or wider than white narrow width
    CHARACTERS = "0123456789-$:/.+ABCD".freeze
    # even: black, odd: white
    # 0: narrow, 1: wide
    BINARY_EXPRESSION = [
      "0000011", # 0
      "0000110", # 1
      "0001001", # 2
      "1100000", # 3
      "0010010", # 4
      "1000010", # 5
      "0100001", # 6
      "0100100", # 7
      "0110000", # 8
      "1001000", # 9
      "0001100", # -
      "0011000", # $
      "1000101", # :
      "1010001", # /
      "1010100", # .
      "0010101", # +
      "0011010", # A
      "0101001", # B
      "0001011", # C
      "0001110", # D
    ].each(&:freeze)
    CHARACTER_TO_BINARY = Hash[CHARACTERS.chars.zip(BINARY_EXPRESSION)].freeze
    FORMAT = /\A[ABCD][0123456789\-\$:\/\.\+]+[ABCD]\z/.freeze
    ONE = "1".freeze
    ZERO = "0".freeze

    attr_accessor :data, :black_narrow_width, :white_narrow_width, :wide_width_rate, :spacing

    def initialize(data)
      self.data = data
      raise ArgumentError, 'data not valid' unless valid?

      self.black_narrow_width = BLACK_NARROW_WIDTH
      self.white_narrow_width = WHITE_NARROW_WIDTH
      self.wide_width_rate = WIDE_WIDTH_RATE
      self.spacing = SPACING
    end

    def encoding
      data.chars.map{|c| binary_to_bars(CHARACTER_TO_BINARY[c]) }.join(ZERO * spacing)
    end

    def valid?
      data =~ FORMAT
    end

    private
    def binary_to_bars(bin)
      bin.chars.each_with_index.map{|c, i|
        black = i % 2 == 0
        narrow = c == ZERO

        if black
          if narrow
            ONE * black_narrow_width
          else
            ONE * (black_narrow_width * wide_width_rate).to_i
          end
        else
          if narrow
            ZERO * white_narrow_width
          else
            ZERO * (white_narrow_width * wide_width_rate).to_i
          end
        end
      }.join
    end
  end
end
