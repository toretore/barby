require 'barby/barcode'

module Barby


  class UPCSupplemental < Barby::Barcode1D
    @data = nil
    attr_reader :data

    FORMAT = /^\d\d\d\d\d$/

    START = '1011'
    STOP = ''
    INTER_CHAR = '01'

    PARITY_MAPS = {
        0 => [:even, :even, :odd, :odd, :odd],
        1 => [:even, :odd, :even, :odd, :odd],
        2 => [:even, :odd, :odd, :even, :odd],
        3 => [:even, :odd, :odd, :odd, :even],
        4 => [:odd, :even, :even, :odd, :odd],
        5 => [:odd, :odd, :even, :even, :odd],
        6 => [:odd, :odd, :odd, :even, :even],
        7 => [:odd, :even, :odd, :even, :odd],
        8 => [:odd, :even, :odd, :odd, :even],
        9 => [:odd, :odd, :even, :odd, :even]
      }

     ENCODINGS_ODD = {
        0 => '0001101', 1 => '0011001', 2 => '0010011',
        3 => '0111101', 4 => '0100011', 5 => '0110001',
        6 => '0101111', 7 => '0111011', 8 => '0110111',
        9 => '0001011'
      }

      ENCODINGS_EVEN = {
        0 => '0100111', 1 => '0110011', 2 => '0011011',
        3 => '0100001', 4 => '0011101', 5 => '0111001',
        6 => '0000101', 7 => '0010001', 8 => '0001001',
        9 => '0010111'
      }



    def data= data
      @data = data
    end

    def initialize data
      self.data = data
    end

    def encoding
      begin
        data = @data
        return nil if data.length!=5
        sum_odd = data[0].chr.to_i + data[2].chr.to_i + data[4].chr.to_i
        sum_even = data[1].chr.to_i + data[3].chr.to_i
        total = sum_odd * 3 + sum_even * 9
        check_digit = total.modulo(10)
       
        parity_map = PARITY_MAPS[check_digit]

        pos = 0
        e = START
        data_chars = data.split('')
        for digit_char in data_chars
          digit = digit_char.to_i
          parity = parity_map[pos]
          e +=  ENCODINGS_ODD[digit] if parity==:odd
          e +=  ENCODINGS_EVEN[digit] if parity==:even
          e += INTER_CHAR unless pos == 4
          pos += 1
        end


        return e
      
      rescue
      end
    end

    def two_dimensional?
      return false
    end

    def valid?
      data =~ FORMAT
    end

    def to_s
      data[0,20]
    end

  end


end
