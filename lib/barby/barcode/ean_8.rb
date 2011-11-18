require 'barby/barcode/ean_13'

module Barby

  #EAN-8 is a sub-set of EAN-13, with only 7 (8) digits
  class EAN8 < EAN13

    FORMAT = /^\d{7}$/


    def left_numbers
      numbers[0,4]
    end

    def right_numbers
      numbers_with_checksum[4,4]
    end


    #Left-hand digits are all encoded using odd parity
    def left_parity_map
      [:odd, :odd, :odd, :odd]
    end


    def valid?
      data =~ FORMAT
    end

  end

end
