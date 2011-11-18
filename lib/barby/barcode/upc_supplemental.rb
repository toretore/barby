require 'barby/barcode'
require 'barby/barcode/ean_13'

module Barby


  class UPCSupplemental < Barby::Barcode1D

    attr_accessor :data

    FORMAT = /^\d\d\d\d\d$|^\d\d$/

    START = '1011'
    SEPARATOR = '01'

    ODD = :odd
    EVEN = :even

    PARITY_MAPS = {
      2 => {
        0 => [ODD, ODD],
        1 => [ODD, EVEN],
        2 => [EVEN, ODD],
        3 => [EVEN, EVEN]
      },
      5 => {
        0 => [EVEN, EVEN, ODD, ODD, ODD],
        1 => [EVEN, ODD, EVEN, ODD, ODD],
        2 => [EVEN, ODD, ODD, EVEN, ODD],
        3 => [EVEN, ODD, ODD, ODD, EVEN],
        4 => [ODD, EVEN, EVEN, ODD, ODD],
        5 => [ODD, ODD, EVEN, EVEN, ODD],
        6 => [ODD, ODD, ODD, EVEN, EVEN],
        7 => [ODD, EVEN, ODD, EVEN, ODD],
        8 => [ODD, EVEN, ODD, ODD, EVEN],
        9 => [ODD, ODD, EVEN, ODD, EVEN]
      }
    }

    ENCODINGS = {
      ODD => EAN13::LEFT_ENCODINGS_ODD,
      EVEN => EAN13::LEFT_ENCODINGS_EVEN
    }


    def initialize(data)
      self.data = data
    end


    def size
      data.size
    end

    def two_digit?
      size == 2
    end

    def five_digit?
      size == 5
    end


    def characters
      data.split(//)
    end

    def digits
      characters.map{|c| c.to_i }
    end


    #Odd and even methods are only useful for 5 digits
    def odd_digits
      alternater = false
      digits.reverse.select{ alternater = !alternater }
    end

    def even_digits
      alternater = true
      digits.reverse.select{ alternater = !alternater }
    end

    def odd_sum
      odd_digits.inject(0){|s,d| s + d * 3 }
    end

    def even_sum
      even_digits.inject(0){|s,d| s + d * 9 }
    end


    #Checksum is different for 2 and 5 digits
    #2-digits don't really have a checksum, just a remainder to look up the parity
    def checksum
      if two_digit?
        data.to_i % 4
      elsif five_digit?
        (odd_sum + even_sum) % 10
      end
    end


    #Parity maps are different for 2 and 5 digits
    def parity_map
      PARITY_MAPS[size][checksum]
    end


    def encoded_characters
      parity_map.zip(digits).map do |parity, digit|
        ENCODINGS[parity][digit]
      end
    end


    def encoding
      START + encoded_characters.join(SEPARATOR)
    end


    def valid?
      data =~ FORMAT
    end


    def to_s
      data
    end


    NO_PRICE = new('90000') #The book doesn't have a suggested retail price
    COMPLIMENTARY = new('99991') #The book is complimentary (~free)
    USED = new('99990') #The book is marked as used


  end


end
