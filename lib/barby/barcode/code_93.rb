#encoding: ASCII
require 'barby/barcode'

module Barby

  class Code93 < Barcode1D

    SHIFT_DOLLAR  = "\301" # ($)
    SHIFT_PERCENT = "\302" # (%)
    SHIFT_SLASH   = "\303" # (/)
    SHIFT_PLUS    = "\304" # (+)

    SHIFT_CHARACTERS = [SHIFT_DOLLAR, SHIFT_PERCENT, SHIFT_SLASH, SHIFT_PLUS]

    ENCODINGS = {
      "0" => "100010100", "1" => "101001000",
      "2" => "101000100", "3" => "101000010",
      "4" => "100101000", "5" => "100100100",
      "6" => "100100010", "7" => "101010000",
      "8" => "100010010", "9" => "100001010",
      "A" => "110101000", "B" => "110100100",
      "C" => "110100010", "D" => "110010100",
      "E" => "110010010", "F" => "110001010",
      "G" => "101101000", "H" => "101100100",
      "I" => "101100010", "J" => "100110100",
      "K" => "100011010", "L" => "101011000",
      "M" => "101001100", "N" => "101000110",
      "O" => "100101100", "P" => "100010110",
      "Q" => "110110100", "R" => "110110010",
      "S" => "110101100", "T" => "110100110",
      "U" => "110010110", "V" => "110011010",
      "W" => "101101100", "X" => "101100110",
      "Y" => "100110110", "Z" => "100111010",
      "-" => "100101110", "." => "111010100",
      " " => "111010010", "$" => "111001010",
      "/" => "101101110", "+" => "101110110",
      "%" => "110101110",
      SHIFT_DOLLAR  => "100100110",
      SHIFT_PERCENT => "111011010",
      SHIFT_SLASH   => "111010110",
      SHIFT_PLUS    => "100110010"
    }

    EXTENDED_MAPPING = {
      "\000" => "\302U",    " "    => " ",        "@"  => "\302V", "`"    =>    "\302W",
      "\001" => "\301A",    "!"    => "\303A",    "A"  => "A",     "a"    =>    "\304A",
      "\002" => "\301B",    '"'    => "\303B",    "B"  => "B",     "b"    =>    "\304B",
      "\003" => "\301C",    "#"    => "\303C",    "C"  => "C",     "c"    =>    "\304C",
      "\004" => "\301D",    "$"    => "\303D",    "D"  => "D",     "d"    =>    "\304D",
      "\005" => "\301E",    "%"    => "\303E",    "E"  => "E",     "e"    =>    "\304E",
      "\006" => "\301F",    "&"    => "\303F",    "F"  => "F",     "f"    =>    "\304F",
      "\007" => "\301G",    "'"    => "\303G",    "G"  => "G",     "g"    =>    "\304G",
      "\010" => "\301H",    "("    => "\303H",    "H"  => "H",     "h"    =>    "\304H",
      "\011" => "\301I",    ")"    => "\303I",    "I"  => "I",     "i"    =>    "\304I",
      "\012" => "\301J",    "*"    => "\303J",    "J"  => "J",     "j"    =>    "\304J",
      "\013" => "\301K",    "/"    => "\303K",    "K"  => "K",     "k"    =>    "\304K",
      "\014" => "\301L",    ","    => "\303L",    "L"  => "L",     "l"    =>    "\304L",
      "\015" => "\301M",    "-"    => "-",        "M"  => "M",     "m"    =>    "\304M",
      "\016" => "\301N",    "."    => ".",        "N"  => "N",     "n"    =>    "\304N",
      "\017" => "\301O",    "+"    => "\303O",    "O"  => "O",     "o"    =>    "\304O",
      "\020" => "\301P",    "0"    => "0",        "P"  => "P",     "p"    =>    "\304P",
      "\021" => "\301Q",    "1"    => "1",        "Q"  => "Q",     "q"    =>    "\304Q",
      "\022" => "\301R",    "2"    => "2",        "R"  => "R",     "r"    =>    "\304R",
      "\023" => "\301S",    "3"    => "3",        "S"  => "S",     "s"    =>    "\304S",
      "\024" => "\301T",    "4"    => "4",        "T"  => "T",     "t"    =>    "\304T",
      "\025" => "\301U",    "5"    => "5",        "U"  => "U",     "u"    =>    "\304U",
      "\026" => "\301V",    "6"    => "6",        "V"  => "V",     "v"    =>    "\304V",
      "\027" => "\301W",    "7"    => "7",        "W"  => "W",     "w"    =>    "\304W",
      "\030" => "\301X",    "8"    => "8",        "X"  => "X",     "x"    =>    "\304X",
      "\031" => "\301Y",    "9"    => "9",        "Y"  => "Y",     "y"    =>    "\304Y",
      "\032" => "\301Z",    ":"    => "\303Z",    "Z"  => "Z",     "z"    =>    "\304Z",
      "\033" => "\302A",    ";"    => "\302F",    "["  => "\302K", "{"    =>    "\302P",
      "\034" => "\302B",    "<"    => "\302G",    "\\" => "\302L", "|"    =>    "\302Q",
      "\035" => "\302C",    "="    => "\302H",    "]"  => "\302M", "}"    =>    "\302R",
      "\036" => "\302D",    ">"    => "\302I",    "^"  => "\302N", "~"    =>    "\302S",
      "\037" => "\302E",    "?"    => "\302J",    "_"  => "\302O", "\177" =>    "\302T"
    }

    EXTENDED_CHARACTERS = EXTENDED_MAPPING.keys - ENCODINGS.keys

    CHARACTERS = {
      0  => "0",  1 => "1", 2  => "2", 3  => "3",
      4  => "4",  5 => "5", 6  => "6", 7  => "7",
      8  => "8",  9 => "9", 10 => "A", 11 => "B",
      12 => "C", 13 => "D", 14 => "E", 15 => "F",
      16 => "G", 17 => "H", 18 => "I", 19 => "J",
      20 => "K", 21 => "L", 22 => "M", 23 => "N",
      24 => "O", 25 => "P", 26 => "Q", 27 => "R",
      28 => "S", 29 => "T", 30 => "U", 31 => "V",
      32 => "W", 33 => "X", 34 => "Y", 35 => "Z",
      36 => "-", 37 => ".", 38 => " ", 39 => "$",
      40 => "/", 41 => "+", 42 => "%",
      43 => SHIFT_DOLLAR, 44 => SHIFT_PERCENT,
      45 => SHIFT_SLASH,  46 => SHIFT_PLUS
    }
    
    VALUES = CHARACTERS.invert

    START_ENCODING     = '101011110' # *
    STOP_ENCODING      = '101011110'
    TERMINATE_ENCODING = '1'

    attr_accessor :data


    def initialize(data)
      self.data = data
    end


    def extended?
      raw_characters.any?{|c| EXTENDED_CHARACTERS.include?(c) }
    end


    def raw_characters
      data.split(//)
    end

    def characters
      raw_characters.map{|c| EXTENDED_MAPPING[c].split(//) }.flatten
    end

    def encoded_characters
      characters.map{|c| ENCODINGS[c] }
    end
    alias character_encodings encoded_characters


    def start_encoding
      START_ENCODING
    end

    #The stop encoding includes the termination bar
    def stop_encoding
      STOP_ENCODING+TERMINATE_ENCODING
    end


    def encoding
      start_encoding+data_encoding_with_checksums+stop_encoding
    end

    def data_encoding
      character_encodings.join
    end

    def data_encoding_with_checksums
      (character_encodings + checksum_encodings).join
    end

    def checksum_encodings
      checksum_characters.map{|c| ENCODINGS[c] }
    end

    def checksum_encoding
      checksum_encodings.join
    end


    def checksums
      [c_checksum, k_checksum]
    end

    def checksum_characters
      checksums.map{|s| CHARACTERS[s] }
    end


    #Returns the values used for computing the C checksum
    #in the "right" order (i.e. reversed)
    def checksum_values
      characters.map{|c| VALUES[c] }.reverse
    end

    #Returns the normal checksum plus the c_checksum
    #This is used for calculating the k_checksum
    def checksum_values_with_c_checksum
      [c_checksum] + checksum_values
    end


    #Calculates the C checksum based on checksum_values
    def c_checksum
      sum = 0
      checksum_values.each_with_index do |value, index|
        sum += ((index % 20) + 1) * value
      end
      sum % 47
    end

    def c_checksum_character
      CHARACTERS[c_checksum]
    end

    def c_checksum_encoding
      ENCODINGS[c_checksum_character]
    end


    #Calculates the K checksum based on checksum_values_with_c_checksum
    def k_checksum
      sum = 0
      checksum_values_with_c_checksum.each_with_index do |value, index|
        sum += ((index % 15) + 1) * value
      end
      sum % 47
    end

    def k_checksum_character
      CHARACTERS[k_checksum]
    end

    def k_checksum_encoding
      ENCODINGS[k_checksum_character]
    end


    def valid?
      characters.all?{|c| ENCODINGS.include?(c) }
    end


    def to_s
      data
    end


  end

end
