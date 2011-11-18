require 'barby/barcode'

module Barby

  #EAN-13, aka UPC-A, barcodes are the ones you can see at your local
  #supermarket, in your house and, well, everywhere..
  #
  #To use this for a UPC barcode, just add a 0 to the front
  class EAN13 < Barcode1D

    LEFT_ENCODINGS_ODD = {
      0 => '0001101', 1 => '0011001', 2 => '0010011',
      3 => '0111101', 4 => '0100011', 5 => '0110001',
      6 => '0101111', 7 => '0111011', 8 => '0110111',
      9 => '0001011'
    }

    LEFT_ENCODINGS_EVEN = {
      0 => '0100111', 1 => '0110011', 2 => '0011011',
      3 => '0100001', 4 => '0011101', 5 => '0111001',
      6 => '0000101', 7 => '0010001', 8 => '0001001',
      9 => '0010111'
    }

    RIGHT_ENCODINGS = {
      0 => '1110010', 1 => '1100110', 2 => '1101100',
      3 => '1000010', 4 => '1011100', 5 => '1001110',
      6 => '1010000', 7 => '1000100', 8 => '1001000',
      9 => '1110100'
    }

    #Describes whether the left-hand encoding should use
    #LEFT_ENCODINGS_ODD or LEFT_ENCODINGS_EVEN, based on the
    #first digit in the number system  (and the barcode as a whole)
    LEFT_PARITY_MAPS = {
      0 => [:odd, :odd, :odd, :odd, :odd, :odd],   #UPC-A
      1 => [:odd, :odd, :even, :odd, :even, :even],
      2 => [:odd, :odd, :even, :even, :odd, :even],
      3 => [:odd, :odd, :even, :even, :even, :odd],
      4 => [:odd, :even, :odd, :odd, :even, :even],
      5 => [:odd, :even, :even, :odd, :odd, :even],
      6 => [:odd, :even, :even, :even, :odd, :odd],
      7 => [:odd, :even, :odd, :even, :odd, :even],
      8 => [:odd, :even, :odd, :even, :even, :odd],
      9 => [:odd, :even, :even, :odd, :even, :odd]
    }

    #These are the lines that "stick down" in the graphical representation
    START = '101'
    CENTER = '01010'
    STOP = '101'

    #EAN-13 barcodes have 12 digits + check digit
    FORMAT = /^\d{12}$/

    attr_accessor :data


    def initialize(data)
      self.data = data
      raise ArgumentError, 'data not valid' unless valid?
    end


    def characters
      data.split(//)
    end
    
    def numbers
      characters.map{|s| s.to_i }
    end

    def odd_and_even_numbers
      alternater = false
      numbers.reverse.partition{ alternater = !alternater }
    end

    #Numbers that are encoded to the left of the center
    #The first digit is not included
    def left_numbers
      numbers[1,6]
    end

    #Numbers that are encoded to the right of the center
    #The checksum is included here
    def right_numbers
      numbers_with_checksum[7,6]
    end

    def numbers_with_checksum
      numbers + [checksum]
    end


    def data_with_checksum
      data + checksum.to_s
    end


    def left_encodings
      left_parity_map.zip(left_numbers).map do |parity,number|
        parity == :odd ? LEFT_ENCODINGS_ODD[number] : LEFT_ENCODINGS_EVEN[number]
      end
    end

    def right_encodings
      right_numbers.map{|n| RIGHT_ENCODINGS[n] }
    end

    def left_encoding
      left_encodings.join
    end

    def right_encoding
      right_encodings.join
    end

    def encoding
      start_encoding+left_encoding+center_encoding+right_encoding+stop_encoding
    end


    #The parities to use for encoding left-hand numbers
    def left_parity_map
      LEFT_PARITY_MAPS[numbers.first]
    end


    def weighted_sum
      odds, evens = odd_and_even_numbers
      odds.map!{|n| n * 3 }
      sum = (odds+evens).inject(0){|s,n| s+n }
    end

    #Mod10
    def checksum
      mod = weighted_sum % 10
      mod.zero? ? 0 : 10-mod
    end

    def checksum_encoding
      RIGHT_ENCODINGS[checksum]
    end


    def valid?
      data =~ FORMAT
    end


    def to_s
      data_with_checksum
    end


    #Is this a UPC-A barcode?
    #UPC barcodes are EAN codes that start with 0
    def upc?
      numbers.first.zero?
    end


    def start_encoding
      START
    end

    def center_encoding
      CENTER
    end

    def stop_encoding
      STOP
    end


  end

  class UPCA < EAN13

    def data
      '0' + super
    end

  end

end
