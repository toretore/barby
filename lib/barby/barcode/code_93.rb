require 'barby/barcode'

module Barby

  class Code93 < Barcode1D

    SHIFT_DOLLAR  = "\301" # ($)
    SHIFT_PERCENT = "\302" # (%)
    SHIFT_SLASH   = "\303" # (/)
    SHIFT_PLUS    = "\304" # (+)

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

#    EXTENDED_ENCODINGS = {
#      "\000" => "%U",    " " => " ",     "@"  => "%V",    "`" =>    "%W",
#      "\001" => "$A",    "!" => "/A",    "A"  => "A",     "a" =>    "+A",
#      "\002" => "$B",    '"' => "/B",    "B"  => "B",     "b" =>    "+B",
#      "\003" => "$C",    "#" => "/C",    "C"  => "C",     "c" =>    "+C",
#      "\004" => "$D",    "$" => "/D",    "D"  => "D",     "d" =>    "+D",
#      "\005" => "$E",    "%" => "/E",    "E"  => "E",     "e" =>    "+E",
#      "\006" => "$F",    "&" => "/F",    "F"  => "F",     "f" =>    "+F",
#      "\007" => "$G",    "'" => "/G",    "G"  => "G",     "g" =>    "+G",
#      "\010" => "$H",    "(" => "/H",    "H"  => "H",     "h" =>    "+H",
#      "\011" => "$I",    ")" => "/I",    "I"  => "I",     "i" =>    "+I",
#      "\012" => "$J",    "*" => "/J",    "J"  => "J",     "j" =>    "+J",
#      "\013" => "$K",    "+" => "/K",    "K"  => "K",     "k" =>    "+K",
#      "\014" => "$L",    "," => "/L",    "L"  => "L",     "l" =>    "+L",
#      "\015" => "$M",    "-" => "-",     "M"  => "M",     "m" =>    "+M",
#      "\016" => "$N",    "." => ".",     "N"  => "N",     "n" =>    "+N",
#      "\017" => "$O",    "/" => "/O",    "O"  => "O",     "o" =>    "+O",
#      "\020" => "$P",    "0" => "0",     "P"  => "P",     "p" =>    "+P",
#      "\021" => "$Q",    "1" => "1",     "Q"  => "Q",     "q" =>    "+Q",
#      "\022" => "$R",    "2" => "2",     "R"  => "R",     "r" =>    "+R",
#      "\023" => "$S",    "3" => "3",     "S"  => "S",     "s" =>    "+S",
#      "\024" => "$T",    "4" => "4",     "T"  => "T",     "t" =>    "+T",
#      "\025" => "$U",    "5" => "5",     "U"  => "U",     "u" =>    "+U",
#      "\026" => "$V",    "6" => "6",     "V"  => "V",     "v" =>    "+V",
#      "\027" => "$W",    "7" => "7",     "W"  => "W",     "w" =>    "+W",
#      "\030" => "$X",    "8" => "8",     "X"  => "X",     "x" =>    "+X",
#      "\031" => "$Y",    "9" => "9",     "Y"  => "Y",     "y" =>    "+Y",
#      "\032" => "$Z",    ":" => "/Z",    "Z"  => "Z",     "z" =>    "+Z",
#      "\033" => "%A",    ";" => "%F",    "["  => "%K",    "{" =>    "%P",
#      "\034" => "%B",    "<" => "%G",    "\\" => "%L",    "|" =>    "%Q",
#      "\035" => "%C",    "=" => "%H",    "]"  => "%M",    "}" =>    "%R",
#      "\036" => "%D",    ">" => "%I",    "^"  => "%N",    "~" =>    "%S",
#      "\037" => "%E",    "?" => "%J",    "_"  => "%O",    "\177" => "%T"
#    }

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
      40 => "/", 41 => "+", 42 => "%"
    }
    
    VALUES = CHARACTERS.invert

    START_ENCODING     = '101011110' # *
    STOP_ENCODING      = '101011110'
    TERMINATE_ENCODING = '1'

    attr_accessor :data


    def initialize(data)
      self.data = data
    end


    def characters
      data.split(//)
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


  end

end
