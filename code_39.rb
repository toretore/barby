require File.join(File.dirname(__FILE__), 'barcode')

module Barby


  class Code39 < Barcode1D

    ENCODINGS = {
      '0' => '101001101101', 'M' => '110110101001',
      '1' => '110100101011', 'N' => '101011010011',
      '2' => '101100101011', 'O' => '110101101001',
      '3' => '110110010101', 'P' => '101101101001',
      '4' => '101001101011', 'Q' => '101010110011',
      '5' => '110100110101', 'R' => '110101011001',
      '6' => '101100110101', 'S' => '101101011001',
      '7' => '101001011011', 'T' => '101011011001',
      '8' => '110100101101', 'U' => '110010101011',
      '9' => '101100101101', 'V' => '100110101011',
      'A' => '110101001011', 'W' => '110011010101',
      'B' => '101101001011', 'X' => '100101101011',
      'C' => '110110100101', 'Y' => '110010110101',
      'D' => '101011001011', 'Z' => '100110110101',
      'E' => '110101100101', '-' => '100101011011',
      'F' => '101101100101', '.' => '110010101101',
      'G' => '101010011011', ' ' => '100110101101',
      'H' => '110101001101', '$' => '100100100101',
      'I' => '101101001101', '/' => '100100101001',
      'J' => '101011001101', '+' => '100101001001',
      'K' => '110101010011', '%' => '101001001001',
      'L' => '101101010011', '*' => '100101101101'
    }

    CHECKSUM_VALUES = {
      '0' => 0,   '1' => 1,   '2' => 2,   '3' => 3,
      '4' => 4,   '5' => 5,   '6' => 6,   '7' => 7,
      '8' => 8,   '9' => 9,   'A' => 10,  'B' => 11,
      'C' => 12,  'D' => 13,  'E' => 14,  'F' => 15,
      'G' => 16,  'H' => 17,  'I' => 18,  'J' => 19,
      'K' => 20,  'L' => 21,  'N' => 23,  'M' => 22,
      'O' => 24,  'P' => 25,  'Q' => 26,  'R' => 27,
      'S' => 28,  'T' => 29,  'U' => 30,  'V' => 31,
      'W' => 32,  'X' => 33,  'Y' => 34,  'Z' => 35,
      '-' => 36,  '.' => 37,  ' ' => 38,  '$' => 39,
      '/' => 40,  '+' => 41,  '%' => 42
    }.invert

    START_CHARACTER = '*'
    STOP_CHARACTER = '*'
    START_ENCODING = ENCODINGS[START_CHARACTER]
    STOP_ENCODING = ENCODINGS[STOP_CHARACTER]

    attr_accessor :data, :spacing
    

    def initialize(data)
      self.data = data
    end


    def characters
      data.split(//)
    end

    def encoded_characters
      characters.map{|c| ENCODINGS[c] }
    end


    def data_encoding
      encoded_characters.join(spacing_encoding)
    end


    def encoding
      start_encoding+spacing_encoding+data_encoding+spacing_encoding+stop_encoding
    end


    def spacing
      @spacing || 1
    end

    def spacing_encoding
      '0' * spacing
    end


    def start_character
      START_CHARACTER
    end

    def stop_character
      STOP_CHARACTER
    end

    def start_encoding
      START_ENCODING
    end

    def stop_encoding
      STOP_ENCODING
    end

    #Code29 can encode all ASCII characters
    def valid?
      characters.all?{|c| c[0] < 128 }
    end


  end


end
