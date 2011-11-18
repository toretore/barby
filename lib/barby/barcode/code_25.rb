require 'barby/barcode'

module Barby


  #Standard/Industrial 2 of 5, non-interleaved
  #
  #Checksum not included by default, to include it,
  #set include_checksum = true
  class Code25 < Barcode1D

    WIDE   = W = true
    NARROW = N = false

    START_ENCODING = [W,W,N]
    STOP_ENCODING  = [W,N,W]

    ENCODINGS = {
      0 => [N,N,W,W,N],
      1 => [W,N,N,N,W],
      2 => [N,W,N,N,W],
      3 => [W,W,N,N,N],
      4 => [N,N,W,N,W],
      5 => [W,N,W,N,N],
      6 => [N,W,W,N,N],
      7 => [N,N,N,W,W],
      8 => [W,N,N,W,N],
      9 => [N,W,N,W,N]
    }

    attr_accessor :data, :narrow_width, :wide_width, :space_width, :include_checksum

  
    def initialize(data)
      self.data = data
    end


    def data_encoding
      digit_encodings.join
    end

    def data_encoding_with_checksum
      digit_encodings_with_checksum.join
    end

    def encoding
      start_encoding+(include_checksum? ? data_encoding_with_checksum : data_encoding)+stop_encoding
    end


    def characters
      data.split(//)
    end

    def characters_with_checksum
      characters.push(checksum.to_s)
    end

    def digits
      characters.map{|c| c.to_i }
    end

    def digits_with_checksum
      digits.push(checksum)
    end

    def even_and_odd_digits
      alternater = false
      digits.reverse.partition{ alternater = !alternater }
    end


    def digit_encodings
      raise_invalid unless valid?
      digits.map{|d| encoding_for(d) }
    end
    alias character_encodings digit_encodings

    def digit_encodings_with_checksum
      raise_invalid unless valid?
      digits_with_checksum.map{|d| encoding_for(d) }
    end
    alias character_encodings_with_checksum digit_encodings_with_checksum


    #Returns the encoding for a single digit
    def encoding_for(digit)
      encoding_for_bars(ENCODINGS[digit])
    end

    #Generate encoding for an array of W,N
    def encoding_for_bars(*bars)
      wide, narrow, space = wide_encoding, narrow_encoding, space_encoding
      bars.flatten.inject '' do |enc,bar|
        enc + (bar == WIDE ? wide : narrow) + space
      end
    end

    def encoding_for_bars_without_end_space(*a)
      encoding_for_bars(*a).gsub(/0+$/, '')
    end


    #Mod10
    def checksum
      evens, odds = even_and_odd_digits
      sum = odds.inject(0){|sum,d| sum + d } + evens.inject(0){|sum,d| sum + (d*3) }
      sum %= 10
      sum.zero? ? 0 : 10-sum
    end

    def checksum_encoding
      encoding_for(checksum)
    end


    #The width of a narrow bar in xdims
    def narrow_width
      @narrow_width || 1
    end

    #The width of a wide bar in xdims
    #By default three times as wide as a narrow bar
    def wide_width
      @wide_width || narrow_width*3
    end

    #The width of the space between the bars in xdims
    #By default the same width as a narrow bar
    #
    #A space serves only as a separator for the bars,
    #there is no encoded meaning in them
    def space_width
      @space_width || narrow_width
    end


    #2 of 5 doesn't require a checksum, but you can include a Mod10 checksum
    #by setting +include_checksum+ to true
    def include_checksum?
      include_checksum
    end


    def data=(data)
      @data = "#{data}"
    end


    def start_encoding
      encoding_for_bars(START_ENCODING)
    end

    def stop_encoding
      encoding_for_bars_without_end_space(STOP_ENCODING)
    end


    def narrow_encoding
      '1' * narrow_width
    end

    def wide_encoding
      '1' * wide_width
    end

    def space_encoding
      '0' * space_width
    end


    def valid?
      data =~ /^[0-9]*$/
    end


    def to_s
      (include_checksum? ? characters_with_checksum : characters).join
    end


  private

    def raise_invalid
      raise ArgumentError, "data not valid"
    end


  end


end
