require 'barby/barcode/code_25'

module Barby

  #Code 2 of 5 interleaved. Same as standard 2 of 5, but spaces are used
  #for encoding as well as the bars. Each pair of numbers get interleaved,
  #that is, the first is encoded in the bars and the second is encoded
  #in the spaced. This means an interleaved 2/5 barcode must have an even
  #number of digits.
  class Code25Interleaved < Code25

    START_ENCODING = [N,N,N,N]
    STOP_ENCODING =  [W,N,N]


    def digit_pairs(d=nil)
      (d || digits).inject [] do |ary,d|
        ary << [] if !ary.last || ary.last.size == 2
        ary.last << d
        ary
      end
    end

    def digit_pairs_with_checksum
      digit_pairs(digits_with_checksum)
    end


    def digit_encodings
      raise_invalid unless valid?
      digit_pairs.map{|p| encoding_for_pair(p) }
    end

    def digit_encodings_with_checksum
      digit_pairs_with_checksum.map{|p| encoding_for_pair(p) }
    end


    def encoding_for_pair(pair)
      bars, spaces = ENCODINGS[pair.first], ENCODINGS[pair.last]
      encoding_for_interleaved(bars.zip(spaces))
    end


    #Encodes an array of interleaved W or N bars and spaces
    #ex: [W,N,W,W,N,N] => "111011100010"
    def encoding_for_interleaved(*bars_and_spaces)
      bar = false#starts with bar
      bars_and_spaces.flatten.inject '' do |enc,bar_or_space|
        bar = !bar
        enc << (bar ? '1' : '0') * (bar_or_space == WIDE ? wide_width : narrow_width)
      end
    end


    def start_encoding
      encoding_for_interleaved(START_ENCODING)
    end

    def stop_encoding
      encoding_for_interleaved(STOP_ENCODING)
    end


    def valid?
      #                           When checksum is included, it's included when determining "evenness"
      super && digits.size % 2 == (include_checksum? ? 1 : 0)
    end


  end

end
