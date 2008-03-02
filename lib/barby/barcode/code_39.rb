require 'barby/barcode'

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
      'L' => '101101010011'#, '*' => '100101101101'
    }

    #In extended mode, each character is replaced with two characters from the "normal" encoding
    EXTENDED_ENCODINGS = {
      "\000" => '%U',    " " => " ",     "@"  => "%V",    "`" =>    "%W",
      "\001" => '$A',    "!" => "/A",    "A"  => "A",     "a" =>    "+A",
      "\002" => '$B',    '"' => "/B",    "B"  => "B",     "b" =>    "+B",
      "\003" => '$C',    "#" => "/C",    "C"  => "C",     "c" =>    "+C",
      "\004" => '$D',    "$" => "/D",    "D"  => "D",     "d" =>    "+D",
      "\005" => '$E',    "%" => "/E",    "E"  => "E",     "e" =>    "+E",
      "\006" => '$F',    "&" => "/F",    "F"  => "F",     "f" =>    "+F",
      "\007" => '$G',    "'" => "/G",    "G"  => "G",     "g" =>    "+G",
      "\010" => '$H',    "(" => "/H",    "H"  => "H",     "h" =>    "+H",
      "\011" => '$I',    ")" => "/I",    "I"  => "I",     "i" =>    "+I",
      "\012" => '$J',    "*" => "/J",    "J"  => "J",     "j" =>    "+J",
      "\013" => '$K',    "+" => "/K",    "K"  => "K",     "k" =>    "+K",
      "\014" => '$L',    "," => "/L",    "L"  => "L",     "l" =>    "+L",
      "\015" => '$M',    "-" => "-",     "M"  => "M",     "m" =>    "+M",
      "\016" => '$N',    "." => ".",     "N"  => "N",     "n" =>    "+N",
      "\017" => '$O',    "/" => "/O",    "O"  => "O",     "o" =>    "+O",
      "\020" => '$P',    "0" => "0",     "P"  => "P",     "p" =>    "+P",
      "\021" => '$Q',    "1" => "1",     "Q"  => "Q",     "q" =>    "+Q",
      "\022" => '$R',    "2" => "2",     "R"  => "R",     "r" =>    "+R",
      "\023" => '$S',    "3" => "3",     "S"  => "S",     "s" =>    "+S",
      "\024" => '$T',    "4" => "4",     "T"  => "T",     "t" =>    "+T",
      "\025" => '$U',    "5" => "5",     "U"  => "U",     "u" =>    "+U",
      "\026" => '$V',    "6" => "6",     "V"  => "V",     "v" =>    "+V",
      "\027" => '$W',    "7" => "7",     "W"  => "W",     "w" =>    "+W",
      "\030" => '$X',    "8" => "8",     "X"  => "X",     "x" =>    "+X",
      "\031" => '$Y',    "9" => "9",     "Y"  => "Y",     "y" =>    "+Y",
      "\032" => '$Z',    ":" => "/Z",    "Z"  => "Z",     "z" =>    "+Z",
      "\033" => '%A',    ";" => "%F",    "["  => "%K",    "{" =>    "%P",
      "\034" => '%B',    "<" => "%G",    "\\" => "%L",    "|" =>    "%Q",
      "\035" => '%C',    "=" => "%H",    "]"  => "%M",    "}" =>    "%R",
      "\036" => '%D',    ">" => "%I",    "^"  => "%N",    "~" =>    "%S",
      "\037" => '%E',    "?" => "%J",    "_"  => "%O",    "\177" => "%T"
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
    }

    START_ENCODING = '100101101101' # *
    STOP_ENCODING = '100101101101'  # *

    attr_accessor :data, :spacing, :extended, :include_checksum
    

    def initialize(data, extended=false)
      self.data = data
      self.extended = extended
      raise(ArgumentError, "data is not valid (extended=#{extended?})") unless valid?
      yield self if block_given?
    end


    #Returns the characters that were passed in, no matter it they're part of
    #the extended charset or if they're already encodable, "normal" characters
    def raw_characters
      data.split(//)
    end

    #Returns the encodable characters. If extended mode is enabled, each character will
    #first be replaced by two characters from the encodable charset
    def characters
      chars = raw_characters
      extended ? chars.map{|c| EXTENDED_ENCODINGS[c].split(//) }.flatten : chars
    end

    def characters_with_checksum
      characters + [checksum_character]
    end

    def encoded_characters
      characters.map{|c| ENCODINGS[c] }
    end

    def encoded_characters_with_checksum
      encoded_characters + [checksum_encoding]
    end


    #The data part of the encoding (no start+stop characters)
    def data_encoding
      encoded_characters.join(spacing_encoding)
    end

    def data_encoding_with_checksum
      encoded_characters_with_checksum.join(spacing_encoding)
    end


    def encoding
      return encoding_with_checksum if include_checksum?
      start_encoding+spacing_encoding+data_encoding+spacing_encoding+stop_encoding
    end

    def encoding_with_checksum
      start_encoding+spacing_encoding+data_encoding_with_checksum+spacing_encoding+stop_encoding
    end


    #Checksum is optional
    def checksum
      characters.inject(0) do |sum,char|
        sum + CHECKSUM_VALUES[char]
      end % 43
    end

    def checksum_character
      CHECKSUM_VALUES.invert[checksum]
    end

    def checksum_encoding
      ENCODINGS[checksum_character]
    end

    #Set include_checksum to true to make +encoding+ include the checksum
    def include_checksum?
      include_checksum
    end


    #Spacing between the characters in xdims. Spacing will be inserted
    #between each character in the encoding
    def spacing
      @spacing || 1
    end

    def spacing_encoding
      '0' * spacing
    end


    def extended?
      extended
    end


    def start_encoding
      START_ENCODING
    end

    def stop_encoding
      STOP_ENCODING
    end

    def valid?
      if extended?
        raw_characters.all?{|c| EXTENDED_ENCODINGS.include?(c) }
      else
        raw_characters.all?{|c| ENCODINGS.include?(c) }
      end
    end


  end


end
