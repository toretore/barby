#encoding: ASCII
require 'barby/barcode'

module Barby


  #Code 128 barcodes
  #
  #Note that you must provide a type for each object, either by passing a string
  #as a second parameter to Code128.new or by instantiating one of the child classes.
  #
  #You can switch type by using the CODEA, CODEB and CODEC characters:
  #
  # "\305" => A
  # "\306" => B
  # "\307" => C
  #
  #As an example, here's one that starts out as type A and then switches to B and then C:
  #
  #  Code128A.new("ABC123\306def\3074567")
  class Code128 < Barcode1D

    FNC1 = "\xc1"
    FNC2 = "\xc2"
    FNC3 = "\xc3"
    FNC4 = "\xc4"
    CODEA = "\xc5"
    CODEB = "\xc6"
    CODEC = "\xc7"
    SHIFT = "\xc8"
    STARTA = "\xc9"
    STARTB = "\xca"
    STARTC = "\xcb"

    STOP = '11000111010'
    TERMINATE = '11'

    ENCODINGS = {
      0 => "11011001100", 1 => "11001101100", 2 => "11001100110",
      3 => "10010011000", 4 => "10010001100", 5 => "10001001100",
      6 => "10011001000", 7 => "10011000100", 8 => "10001100100",
      9 => "11001001000", 10 => "11001000100", 11 => "11000100100",
      12 => "10110011100", 13 => "10011011100", 14 => "10011001110",
      15 => "10111001100", 16 => "10011101100", 17 => "10011100110",
      18 => "11001110010", 19 => "11001011100", 20 => "11001001110",
      21 => "11011100100", 22 => "11001110100", 23 => "11101101110",
      24 => "11101001100", 25 => "11100101100", 26 => "11100100110",
      27 => "11101100100", 28 => "11100110100", 29 => "11100110010",
      30 => "11011011000", 31 => "11011000110", 32 => "11000110110",
      33 => "10100011000", 34 => "10001011000", 35 => "10001000110",
      36 => "10110001000", 37 => "10001101000", 38 => "10001100010",
      39 => "11010001000", 40 => "11000101000", 41 => "11000100010",
      42 => "10110111000", 43 => "10110001110", 44 => "10001101110",
      45 => "10111011000", 46 => "10111000110", 47 => "10001110110",
      48 => "11101110110", 49 => "11010001110", 50 => "11000101110",
      51 => "11011101000", 52 => "11011100010", 53 => "11011101110",
      54 => "11101011000", 55 => "11101000110", 56 => "11100010110",
      57 => "11101101000", 58 => "11101100010", 59 => "11100011010",
      60 => "11101111010", 61 => "11001000010", 62 => "11110001010",
      63 => "10100110000", 64 => "10100001100", 65 => "10010110000",
      66 => "10010000110", 67 => "10000101100", 68 => "10000100110",
      69 => "10110010000", 70 => "10110000100", 71 => "10011010000",
      72 => "10011000010", 73 => "10000110100", 74 => "10000110010",
      75 => "11000010010", 76 => "11001010000", 77 => "11110111010",
      78 => "11000010100", 79 => "10001111010", 80 => "10100111100",
      81 => "10010111100", 82 => "10010011110", 83 => "10111100100",
      84 => "10011110100", 85 => "10011110010", 86 => "11110100100",
      87 => "11110010100", 88 => "11110010010", 89 => "11011011110",
      90 => "11011110110", 91 => "11110110110", 92 => "10101111000",
      93 => "10100011110", 94 => "10001011110", 95 => "10111101000",
      96 => "10111100010", 97 => "11110101000", 98 => "11110100010",
      99 => "10111011110", 100 => "10111101110", 101 => "11101011110",
      102 => "11110101110", 103 => "11010000100", 104 => "11010010000",
      105 => "11010011100"
    }

    VALUES = {
      'A' => {
        0 => " ",      1 => "!",        2 => "\"",
        3 => "#",       4 => "$",        5 => "%",
        6 => "&",       7 => "'",        8 => "(",
        9 => ")",       10 => "*",       11 => "+",
        12 => ",",      13 => "-",       14 => ".",
        15 => "/",      16 => "0",       17 => "1",
        18 => "2",      19 => "3",       20 => "4",
        21 => "5",      22 => "6",       23 => "7",
        24 => "8",      25 => "9",       26 => ":",
        27 => ";",      28 => "<",       29 => "=",
        30 => ">",      31 => "?",       32 => "@",
        33 => "A",      34 => "B",       35 => "C",
        36 => "D",      37 => "E",       38 => "F",
        39 => "G",      40 => "H",       41 => "I",
        42 => "J",      43 => "K",       44 => "L",
        45 => "M",      46 => "N",       47 => "O",
        48 => "P",      49 => "Q",       50 => "R",
        51 => "S",      52 => "T",       53 => "U",
        54 => "V",      55 => "W",       56 => "X",
        57 => "Y",      58 => "Z",       59 => "[",
        60 => "\\",     61 => "]",       62 => "^",
        63 => "_",      64 => "\000",    65 => "\001",
        66 => "\002",   67 => "\003",    68 => "\004",
        69 => "\005",   70 => "\006",    71 => "\a",
        72 => "\b",     73 => "\t",      74 => "\n",
        75 => "\v",     76 => "\f",      77 => "\r",
        78 => "\016",   79 => "\017",    80 => "\020",
        81 => "\021",   82 => "\022",    83 => "\023",
        84 => "\024",   85 => "\025",    86 => "\026",
        87 => "\027",   88 => "\030",    89 => "\031",
        90 => "\032",   91 => "\e",      92 => "\034",
        93 => "\035",   94 => "\036",    95 => "\037",
        96 => FNC3,     97 => FNC2,      98 => SHIFT,
        99 => CODEC,    100 => CODEB,    101 => FNC4,
        102 => FNC1,    103 => STARTA,   104 => STARTB,
        105 => STARTC
      }.invert,

      'B' => {
        0 => " ", 1 => "!", 2 => "\"", 3 => "#", 4 => "$", 5 => "%",
        6 => "&", 7 => "'", 8 => "(", 9 => ")", 10 => "*", 11 => "+",
        12 => ",", 13 => "-", 14 => ".", 15 => "/", 16 => "0", 17 => "1",
        18 => "2", 19 => "3", 20 => "4", 21 => "5", 22 => "6", 23 => "7",
        24 => "8", 25 => "9", 26 => ":", 27 => ";", 28 => "<", 29 => "=",
        30 => ">", 31 => "?", 32 => "@", 33 => "A", 34 => "B", 35 => "C",
        36 => "D", 37 => "E", 38 => "F", 39 => "G", 40 => "H", 41 => "I",
        42 => "J", 43 => "K", 44 => "L", 45 => "M", 46 => "N", 47 => "O",
        48 => "P", 49 => "Q", 50 => "R", 51 => "S", 52 => "T", 53 => "U",
        54 => "V", 55 => "W", 56 => "X", 57 => "Y", 58 => "Z", 59 => "[",
        60 => "\\", 61 => "]", 62 => "^", 63 => "_", 64 => "`", 65 => "a",
        66 => "b", 67 => "c", 68 => "d", 69 => "e", 70 => "f", 71 => "g",
        72 => "h", 73 => "i", 74 => "j", 75 => "k", 76 => "l", 77 => "m",
        78 => "n", 79 => "o", 80 => "p", 81 => "q", 82 => "r", 83 => "s",
        84 => "t", 85 => "u", 86 => "v", 87 => "w", 88 => "x", 89 => "y",
        90 => "z", 91 => "{", 92 => "|", 93 => "}", 94 => "~", 95 => "\177",
        96 => FNC3, 97 => FNC2, 98 => SHIFT, 99 => CODEC, 100 => FNC4,
        101 => CODEA, 102 => FNC1, 103 => STARTA, 104 => STARTB,
        105 => STARTC,
      }.invert,

      'C' => {
        0 => "00", 1 => "01", 2 => "02", 3 => "03", 4 => "04", 5 => "05",
        6 => "06", 7 => "07", 8 => "08", 9 => "09", 10 => "10", 11 => "11",
        12 => "12", 13 => "13", 14 => "14", 15 => "15", 16 => "16", 17 => "17",
        18 => "18", 19 => "19", 20 => "20", 21 => "21", 22 => "22", 23 => "23",
        24 => "24", 25 => "25", 26 => "26", 27 => "27", 28 => "28", 29 => "29",
        30 => "30", 31 => "31", 32 => "32", 33 => "33", 34 => "34", 35 => "35",
        36 => "36", 37 => "37", 38 => "38", 39 => "39", 40 => "40", 41 => "41",
        42 => "42", 43 => "43", 44 => "44", 45 => "45", 46 => "46", 47 => "47",
        48 => "48", 49 => "49", 50 => "50", 51 => "51", 52 => "52", 53 => "53",
        54 => "54", 55 => "55", 56 => "56", 57 => "57", 58 => "58", 59 => "59",
        60 => "60", 61 => "61", 62 => "62", 63 => "63", 64 => "64", 65 => "65",
        66 => "66", 67 => "67", 68 => "68", 69 => "69", 70 => "70", 71 => "71",
        72 => "72", 73 => "73", 74 => "74", 75 => "75", 76 => "76", 77 => "77",
        78 => "78", 79 => "79", 80 => "80", 81 => "81", 82 => "82", 83 => "83",
        84 => "84", 85 => "85", 86 => "86", 87 => "87", 88 => "88", 89 => "89",
        90 => "90", 91 => "91", 92 => "92", 93 => "93", 94 => "94", 95 => "95",
        96 => "96", 97 => "97", 98 => "98", 99 => "99", 100 => CODEB, 101 => CODEA,
        102 => FNC1, 103 => STARTA, 104 => STARTB, 105 => STARTC
      }.invert
    }

    CONTROL_CHARACTERS = VALUES['A'].invert.values_at(*(64..95).to_a)

    attr_reader :type


    def initialize(data, type=nil)
      if type
        self.type = type
        self.data = "#{data}"
      else
        self.type, self.data = self.class.determine_best_type_for_data("#{data}")
      end
      raise ArgumentError, 'Data not valid' unless valid?
    end


    def type=(type)
      type.upcase!
      raise ArgumentError, 'type must be A, B or C' unless type =~ /^[ABC]$/
      @type = type
    end


    def to_s
      full_data
    end


    def data
      @data
    end

    #Returns the data for this barcode plus that for the entire extra chain,
    #excluding all change codes
    def full_data
      data + full_extra_data
    end

    #Returns the data for this barcode plus that for the entire extra chain,
    #including all change codes prefixing each extra
    def full_data_with_change_codes
      data + full_extra_data_with_change_code
    end

    #Returns the full_data for the extra or an empty string if there is no extra
    def full_extra_data
      return '' unless extra
      extra.full_data
    end

    #Returns the full_data for the extra with the change code for the extra
    #prepended. If there is no extra, an empty string is returned
    def full_extra_data_with_change_code
      return '' unless extra
      change_code_for(extra) + extra.full_data_with_change_codes
    end

    #Set the data for this barcode. If the barcode changes
    #character set, an extra will be created.
    def data=(data)
      data, *extra = data.split(/([#{CODEA+CODEB+CODEC}])/n)
      @data = data || ''
      self.extra = extra.join unless extra.empty?
    end

    #An "extra" is present if the barcode changes character set. If
    #a 128A barcode changes to C, the extra will be an instance of
    #Code128C. Extras can themselves have an extra if the barcode
    #changes character set again. It's like a linked list, and when
    #there are no more extras, the barcode ends with that object.
    #Most barcodes probably don't change charsets and don't have extras.
    def extra
      @extra
    end

    #Set the extra for this barcode. The argument is a string starting with the
    #"change character set" symbol. The string may contain several character
    #sets, in which case the extra will itself have an extra.
    def extra=(extra)
      raise ArgumentError, "Extra must begin with \\305, \\306 or \\307" unless extra =~ /^[#{CODEA+CODEB+CODEC}]/n
      type, data = extra[0,1], extra[1..-1]
      @extra = class_for(type).new(data)
    end

    #Get an array of the individual characters for this barcode. Special
    #characters like FNC1 will be present. Characters from extras are not
    #present.
    def characters
      chars = data.split(//n)

      if type == 'C'
        result = []
        count = 0
        while count < chars.size
          if chars[count] =~ /^\d$/
            #If encountering a digit, next char/byte *must* be second digit in pair. I.e. if chars[count] is 5,
            #chars[count+1] must be /[0-9]/, otherwise it's not valid
            result << "#{chars[count]}#{chars[count+1]}"
            count += 2
          else
            result << chars[count]
            count += 1
          end
        end
        result
      else
        chars
      end
    end

    #Return the encoding of this barcode as a string of 1 and 0
    def encoding
      start_encoding+data_encoding+extra_encoding+checksum_encoding+stop_encoding
    end

    #Returns the encoding for the data part of this barcode, without any extras
    def data_encoding
      characters.map do |char|
        encoding_for char
      end.join
    end

    #Returns the data encoding of this barcode and extras.
    def data_encoding_with_extra_encoding
      data_encoding+extra_encoding
    end

    #Returns the data encoding of this barcode's extra and its
    #extra until the barcode ends.
    def extra_encoding
      return '' unless extra
      change_code_encoding_for(extra) + extra.data_encoding + extra.extra_encoding
    end


    #Calculate the checksum for the data in this barcode. The data includes
    #data from extras.
    def checksum
      pos = 0
      (numbers+extra_numbers).inject(start_num) do |sum,number|
        pos += 1
        sum + (number * pos)
      end % 103
    end

    #Get the encoding for the checksum
    def checksum_encoding
      encodings[checksum]
    end


  #protected

    #Returns the numeric values for the characters in the barcode in an array
    def numbers
      characters.map do |char|
        values[char]
      end
    end

    #Returns the numeric values for extras
    def extra_numbers
      return [] unless extra
      [change_code_number_for(extra)] + extra.numbers + extra.extra_numbers
    end

    def encodings
      ENCODINGS
    end

    #The start encoding starts the barcode
    def stop_encoding
      STOP+TERMINATE
    end

    #Find the encoding for the specified character for this barcode
    def encoding_for(char)
      encodings[values[char]]
    end

    def change_code_for_class(klass)
      {Code128A => CODEA, Code128B => CODEB, Code128C => CODEC}[klass]
    end

    #Find the character that changes the character set to the one
    #represented in +barcode+
    def change_code_for(barcode)
      change_code_for_class(barcode.class)
    end

    #Find the numeric value for the character that changes the character
    #set to the one represented in +barcode+
    def change_code_number_for(barcode)
      values[change_code_for(barcode)]
    end

    #Find the encoding to change to the character set in +barcode+
    def change_code_encoding_for(barcode)
      encodings[change_code_number_for(barcode)]
    end

    def class_for(character)
      self.class.class_for(character)
    end

    #Is the data in this barcode valid? Does a lookup of every character
    #and checks if it exists in the character set. An empty data string
    #will also be reported as invalid.
    def valid?
      characters.any? && characters.all?{|c| values.include?(c) }
    end

    def values
      VALUES[type]
    end

    def start_character
      case type
      when 'A' then STARTA
      when 'B' then STARTB
      when 'C' then STARTC
      end
    end

    def start_num
      values[start_character]
    end

    def start_encoding
      encodings[start_num]
    end



    CTRL_RE = /#{CONTROL_CHARACTERS.join('|')}/
    LOWR_RE = /[a-z]/
    DGTS_RE = /\d{4,}/

    class << self


      def class_for(character)
        case character
        when 'A' then Code128A
        when 'B' then Code128B
        when 'C' then Code128C
        when CODEA then Code128A
        when CODEB then Code128B
        when CODEC then Code128C
        end
      end


      #Insert code shift and switch characters where appropriate to get the
      #shortest encoding possible
      def apply_shortest_encoding_for_data(data)
        extract_codec(data).map do |block|
          if possible_codec_segment?(block)
            "#{CODEC}#{block}"
          else
            if control_before_lowercase?(block)
              handle_code_a(block)
            else
              handle_code_b(block)
            end
          end
        end.join
      end

      def determine_best_type_for_data(data)
        data = apply_shortest_encoding_for_data(data)
        type = case data.slice!(0)
               when CODEA then 'A'
               when CODEB then 'B'
               when CODEC then 'C'
               end
        [type, data]
      end


    private

      #Extract all CODEC segments from the data. 4 or more evenly numbered contiguous digits.
      #
      #  #                                        C       A or B  C         A or B
      #  extract_codec("12345abc678910DEF11") => ["1234", "5abc", "678910", "DEF11"]
      def extract_codec(data)
        segments = data.split(/(\d{4,})/).reject(&:empty?)
        segments.each_with_index do |s,i|
          if possible_codec_segment?(s) && s.size.odd?
            if i == 0
              if segments[1]
                segments[1].insert(0, s.slice!(-1))
              else
                segments[1] = s.slice!(-1)
              end
            else
              segments[i-1].insert(-1, s.slice!(0)) if segments[i-1]
            end
          end
        end
        segments
      end

      def possible_codec_segment?(data)
        data =~ /\A\d{4,}\Z/
      end

      def control_character?(char)
        char =~ CTRL_RE
      end

      def lowercase_character?(char)
        char =~ LOWR_RE
      end


      #Handle a Code A segment which may contain Code B parts, but may not
      #contain any Code C parts.
      def handle_code_a(data)
        indata = data.dup
        outdata = CODEA.dup #We know it'll be A
        while char = indata.slice!(0)
          if lowercase_character?(char) #Found a lower case character (Code B)
            if control_before_lowercase?(indata)
              outdata << SHIFT << char #Control character appears before a new lowercase, use shift
            else
              outdata << handle_code_b(char+indata) #Switch to Code B
              break
            end
          else
            outdata << char
          end
        end#while

        outdata
      end


      #Handle a Code B segment which may contain Code A parts, but may not
      #contain any Code C parts.
      def handle_code_b(data)
        indata = data.dup
        outdata = CODEB.dup #We know this is going to start with Code B
        while char = indata.slice!(0)
          if control_character?(char) #Found a control character (Code A)
            if control_before_lowercase?(indata)    #There is another control character before any lowercase, so
              outdata << handle_code_a(char+indata) #switch over to Code A.
              break
            else
              outdata << SHIFT << char #Can use a shift to only encode this char as Code A
            end
          else
            outdata << char
          end
        end#while

        outdata
      end


      #Test str to see if a control character (Code A) appears
      #before a lower case character (Code B).
      #
      #Returns true only if it contains a control character and a lower case
      #character doesn't appear before it.
      def control_before_lowercase?(str)
        ctrl = str =~ CTRL_RE
        char = str =~ LOWR_RE

        ctrl && (!char || ctrl < char)
      end



    end#class << self



  end#class Code128


  class Code128A < Code128

    def initialize(data)
      super(data, 'A')
    end

  end


  class Code128B < Code128

    def initialize(data)
      super(data, 'B')
    end

  end


  class Code128C < Code128

    def initialize(data)
      super(data, 'C')
    end

  end


end
