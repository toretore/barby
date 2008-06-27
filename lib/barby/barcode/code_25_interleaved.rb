require 'barby/barcode/code_25'

module Barby

  class Code25Interleaved < Code25

    START_ENCODING = [N,N,N,N]
    STOP_ENCODING =  [W,N,N]


    def data_encoding
      digit_pair_encodings.join
    end


    def character_pairs
      chars = characters
      pairs = Array.new((chars.size/2.0).ceil){ [] }
      chars.each_with_index{|c,i| pairs[(i/2.0).floor] << c }
      pairs
    end

    def digit_pairs
      d = digits
      pairs = Array.new((d.size/2.0).ceil){ [] }
      d.each_with_index{|dd,i| pairs[(i/2.0).floor] << dd }
      pairs
    end


    def digit_pair_encodings
      digit_pairs.map{|p| encoding_for_pair(p) }
    end


    def encoding_for_pair(pair)
      bars, spaces = ENCODINGS[pair.first], ENCODINGS[pair.last]
      bars.zip(spaces).inject '' do |enc,p|
        bar, space = *p
        enc + ('1' *  (bar == WIDE ? wide_width : narrow_width)) +
        ('0' *  (space == WIDE ? wide_width : narrow_width))
      end
    end

    #def encoding_for_bars(*bars_and_spaces)
    #  bar = false
    #  bars_and_spaces.flatten.inject '' do |enc,bar_or_space|
    #    bar = !bar
    #    enc + (bar ? '1' : '0')*(bar_or_space == WIDE ? wide_width : narrow_width)
    #  end
    #end


    def start_encoding
      bar = false
      START_ENCODING.inject '' do |enc,bar_or_space|
        bar = !bar
        enc << (bar ? '1' : '0') * (bar_or_space == WIDE ? wide_width : narrow_width)
      end
    end

    def stop_encoding
      bar = false
      STOP_ENCODING.inject '' do |enc,bar_or_space|
        bar = !bar
        enc << (bar ? '1' : '0') * (bar_or_space == WIDE ? wide_width : narrow_width)
      end
    end


  end

end
