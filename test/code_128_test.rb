require 'test_helper'
require 'barby/barcode/code_128'

class Code128Test < Barby::TestCase

  %w[CODEA CODEB CODEC FNC1 FNC2 FNC3 FNC4 SHIFT].each do |const|
    const_set const, Code128.const_get(const)
  end

  before do
    @data = 'ABC123'
    @code = Code128A.new(@data)
  end

  it "should have the expected stop encoding (including termination bar 11)" do
    assert_equal '1100011101011', @code.send(:stop_encoding)
  end

  it "should find the right class for a character A, B or C" do
    assert_equal Code128A, @code.send(:class_for, 'A')
    assert_equal Code128B, @code.send(:class_for, 'B')
    assert_equal Code128C, @code.send(:class_for, 'C')
  end

  it "should find the right change code for a class" do
    assert_equal Code128::CODEA, @code.send(:change_code_for_class, Code128A)
    assert_equal Code128::CODEB, @code.send(:change_code_for_class, Code128B)
    assert_equal Code128::CODEC, @code.send(:change_code_for_class, Code128C)
  end

  it "should not allow empty data" do
    assert_raises ArgumentError do
      Code128B.new("")
    end
  end

  describe "single encoding" do

    before do
      @data = 'ABC123'
      @code = Code128A.new(@data)
    end

    it "should have the same data as when initialized" do
      assert_equal @data, @code.data
    end

    it "should be able to change its data" do
      @code.data = '123ABC'
      assert_equal '123ABC', @code.data
      refute_equal @data, @code.data
    end

    it "should not have an extra" do
      assert @code.extra.nil?
    end

    it "should have empty extra encoding" do
      assert_equal '', @code.extra_encoding
    end

    it "should have the correct checksum" do
      assert_equal 66, @code.checksum
    end

    it "should return all data for to_s" do
      assert_equal @data, @code.to_s
    end

  end

  describe "multiple encodings" do

    before do
      @data = binary_encode("ABC123\306def\3074567")
      @code = Code128A.new(@data)
    end

    it "should be able to return full_data which includes the entire extra chain excluding charset change characters" do
      assert_equal "ABC123def4567", @code.full_data
    end

    it "should be able to return full_data_with_change_codes which includes the entire extra chain including charset change characters" do
      assert_equal @data, @code.full_data_with_change_codes
    end

    it "should not matter if extras were added separately" do
      code = Code128B.new("ABC")
      code.extra = binary_encode("\3071234")
      assert_equal "ABC1234", code.full_data
      assert_equal binary_encode("ABC\3071234"), code.full_data_with_change_codes
      code.extra.extra = binary_encode("\306abc")
      assert_equal "ABC1234abc", code.full_data
      assert_equal binary_encode("ABC\3071234\306abc"), code.full_data_with_change_codes
      code.extra.extra.data = binary_encode("abc\305DEF")
      assert_equal "ABC1234abcDEF", code.full_data
      assert_equal binary_encode("ABC\3071234\306abc\305DEF"), code.full_data_with_change_codes
      assert_equal "abcDEF", code.extra.extra.full_data
      assert_equal binary_encode("abc\305DEF"), code.extra.extra.full_data_with_change_codes
      assert_equal "1234abcDEF", code.extra.full_data
      assert_equal binary_encode("1234\306abc\305DEF"), code.extra.full_data_with_change_codes
    end

    it "should have a Code B extra" do
      assert @code.extra.is_a?(Code128B)
    end

    it "should have a valid extra" do
      assert @code.extra.valid?
    end

    it "the extra should also have an extra of type C" do
      assert @code.extra.extra.is_a?(Code128C)
    end

    it "the extra's extra should be valid" do
      assert @code.extra.extra.valid?
    end

    it "should not have more than two extras" do
      assert @code.extra.extra.extra.nil?
    end

    it "should split extra data from string on data assignment" do
      @code.data = binary_encode("123\306abc")
      assert_equal '123', @code.data
      assert @code.extra.is_a?(Code128B)
      assert_equal 'abc', @code.extra.data
    end

    it "should be be able to change its extra" do
      @code.extra = binary_encode("\3071234")
      assert @code.extra.is_a?(Code128C)
      assert_equal '1234', @code.extra.data
    end

    it "should split extra data from string on extra assignment" do
      @code.extra = binary_encode("\306123\3074567")
      assert @code.extra.is_a?(Code128B)
      assert_equal '123', @code.extra.data
      assert @code.extra.extra.is_a?(Code128C)
      assert_equal '4567', @code.extra.extra.data
    end

    it "should not fail on newlines in extras" do
      code = Code128B.new(binary_encode("ABC\305\n"))
      assert_equal "ABC", code.data
      assert code.extra.is_a?(Code128A)
      assert_equal "\n", code.extra.data
      code.extra.extra = binary_encode("\305\n\n\n\n\n\nVALID")
      assert_equal "\n\n\n\n\n\nVALID", code.extra.extra.data
    end

    it "should raise an exception when extra string doesn't start with the special code character" do
      assert_raises ArgumentError do
        @code.extra = '123'
      end
    end

    it "should have the correct checksum" do
      assert_equal 84, @code.checksum
    end

    it "should have the expected encoding" do
                 #STARTA     A          B          C          1          2          3
      expected = '11010000100101000110001000101100010001000110100111001101100111001011001011100'+
                 #CODEB      d          e          f
                 '10111101110100001001101011001000010110000100'+
                 #CODEC      45         67
                 '101110111101011101100010000101100'+
                 #CHECK=84   STOP
                 '100111101001100011101011'
      assert_equal expected, @code.encoding
    end

    it "should return all data including extras, except change codes for to_s" do
      assert_equal "ABC123def4567", @code.to_s
    end

  end

  describe "128A" do

    before do
      @data = 'ABC123'
      @code = Code128A.new(@data)
    end

    it "should be valid when given valid data" do
      assert @code.valid?
    end

    it "should not be valid when given invalid data" do
      @code.data = 'abc123'
      refute @code.valid?
    end

    it "should have the expected characters" do
      assert_equal %w(A B C 1 2 3), @code.characters
    end

    it "should have the expected start encoding" do
      assert_equal '11010000100', @code.start_encoding
    end

    it "should have the expected data encoding" do
      assert_equal '101000110001000101100010001000110100111001101100111001011001011100', @code.data_encoding
    end

    it "should have the expected encoding" do
      assert_equal '11010000100101000110001000101100010001000110100111001101100111001011001011100100100001101100011101011', @code.encoding
    end

    it "should have the expected checksum encoding" do
      assert_equal '10010000110', @code.checksum_encoding
    end

  end

  describe "128B" do

    before do
      @data = 'abc123'
      @code = Code128B.new(@data)
    end

    it "should be valid when given valid data" do
      assert @code.valid?
    end

    it "should not be valid when given invalid data" do
      @code.data = binary_encode("abc£123")
      refute @code.valid?
    end

    it "should have the expected characters" do
      assert_equal %w(a b c 1 2 3), @code.characters
    end

    it "should have the expected start encoding" do
      assert_equal '11010010000', @code.start_encoding
    end

    it "should have the expected data encoding" do
      assert_equal '100101100001001000011010000101100100111001101100111001011001011100', @code.data_encoding
    end

    it "should have the expected encoding" do
      assert_equal '11010010000100101100001001000011010000101100100111001101100111001011001011100110111011101100011101011', @code.encoding
    end

    it "should have the expected checksum encoding" do
      assert_equal '11011101110', @code.checksum_encoding
    end

  end

  describe "128C" do

    before do
      @data = '123456'
      @code = Code128C.new(@data)
    end

    it "should be valid when given valid data" do
      assert @code.valid?
    end

    it "should not be valid when given invalid data" do
      @code.data = '123'
      refute @code.valid?
      @code.data = 'abc'
      refute @code.valid?
    end

    it "should have the expected characters" do
      assert_equal %w(12 34 56), @code.characters
    end

    it "should have the expected start encoding" do
      assert_equal '11010011100', @code.start_encoding
    end

    it "should have the expected data encoding" do
      assert_equal '101100111001000101100011100010110', @code.data_encoding
    end

    it "should have the expected encoding" do
      assert_equal '11010011100101100111001000101100011100010110100011011101100011101011', @code.encoding
    end

    it "should have the expected checksum encoding" do
      assert_equal '10001101110', @code.checksum_encoding
    end

  end

  describe "Function characters" do

    it "should retain the special symbols in the data accessor" do
      assert_equal binary_encode("\301ABC\301DEF"), Code128A.new(binary_encode("\301ABC\301DEF")).data
      assert_equal binary_encode("\301ABC\302DEF"), Code128B.new(binary_encode("\301ABC\302DEF")).data
      assert_equal binary_encode("\301123456"), Code128C.new(binary_encode("\301123456")).data
      assert_equal binary_encode("12\30134\30156"), Code128C.new(binary_encode("12\30134\30156")).data
    end

    it "should keep the special symbols as characters" do
      assert_equal binary_encode_array(%W(\301 A B C \301 D E F)), Code128A.new(binary_encode("\301ABC\301DEF")).characters
      assert_equal binary_encode_array(%W(\301 A B C \302 D E F)), Code128B.new(binary_encode("\301ABC\302DEF")).characters
      assert_equal binary_encode_array(%W(\301 12 34 56)), Code128C.new(binary_encode("\301123456")).characters
      assert_equal binary_encode_array(%W(12 \301 34 \301 56)), Code128C.new(binary_encode("12\30134\30156")).characters
    end

    it "should not allow FNC > 1 for Code C" do
      assert_raises(ArgumentError){ Code128C.new("12\302") }
      assert_raises(ArgumentError){ Code128C.new("\30312") }
      assert_raises(ArgumentError){ Code128C.new("12\304") }
    end

    it "should be included in the encoding" do
      a = Code128A.new(binary_encode("\301AB"))
      assert_equal '111101011101010001100010001011000', a.data_encoding
      assert_equal '11010000100111101011101010001100010001011000101000011001100011101011', a.encoding
    end

  end

  describe "Code128 with type" do

    #it "should raise an exception when not given a type" do
    #  lambda{ Code128.new('abc') }.must_raise(ArgumentError)
    #end

    it "should raise an exception when given a non-existent type" do
      assert_raises ArgumentError do
        Code128.new('abc', 'F')
      end
    end

    it "should not fail on frozen type" do
      Code128.new('123456', 'C'.freeze) # not failing
      Code128.new('123456', 'c'.freeze) # not failing even when upcasing
    end

    it "should give the right encoding for type A" do
      code = Code128.new('ABC123', 'A')
      assert_equal '11010000100101000110001000101100010001000110100111001101100111001011001011100100100001101100011101011', code.encoding
    end

    it "should give the right encoding for type B" do
      code = Code128.new('abc123', 'B')
      assert_equal '11010010000100101100001001000011010000101100100111001101100111001011001011100110111011101100011101011', code.encoding
    end

    it "should give the right encoding for type B" do
      code = Code128.new('123456', 'C')
      assert_equal '11010011100101100111001000101100011100010110100011011101100011101011', code.encoding
    end

  end



  describe "Code128 automatic charset" do
=begin
	5.4.7.7. Use of Start, Code Set, and Shift Characters to Minimize Symbol Length (Informative)

	The same data may be represented by different GS1-128 barcodes through the use of different combinations of Start, code set, and shift characters.

	The following rules should normally be implemented in printer control software to minimise the number of symbol characters needed to represent a given data string (and, therefore, reduce the overall symbol length).

	* Determine the Start Character:
	  - If the data consists of two digits, use Start Character C.
	  - If the data begins with four or more numeric data characters, use Start Character C.
	  - If an ASCII symbology element (e.g., NUL) occurs in the data before any lowercase character, use Start Character A.
	  - Otherwise, use Start Character B.
	* If Start Character C is used and the data begins with an odd number of numeric data characters, insert a code set A or code set B character before the last digit, following rules 1c and 1d to determine between code sets A and B.
	* If four or more numeric data characters occur together when in code sets A or B and:
	  - If there is an even number of numeric data characters, then insert a code set C character before the first numeric digit to change to code set C.
	  - If there is an odd number of numeric data characters, then insert a code set C character immediately after the first numeric digit to change to code set C.
	* When in code set B and an ASCII symbology element occurs in the data:
	  - If following that character, a lowercase character occurs in the data before the occurrence of another symbology element, then insert a shift character before the symbology element.
	  - Otherwise, insert a code set A character before the symbology element to change to code set A.
	* When in code set A and a lowercase character occurs in the data:
	  - If following that character, a symbology element occurs in the data before the occurrence of another lowercase character, then insert a shift character before the lowercase character.
	  - Otherwise, insert a code set B character before the lowercase character to change to code set B.
		When in code set C and a non-numeric character occurs in the data, insert a code set A or code set B character before that character, and follow rules 1c and 1d to determine between code sets A and B.

	Note: In these rules, the term “lowercase” is used for convenience to mean any code set B character with Code 128 Symbol character values 64 to 95 (ASCII values 96 to 127) (e.g., all lowercase alphanumeric characters plus `{|}~DEL). The term “symbology element” means any code set A character with Code 128 Symbol character values 64 to 95 (ASCII values 00 to 31).
	Note 2: If the Function 1 Symbol Character (FNC1) occurs in the first position following the Start Character, or in an odd-numbered position in a numeric field, it should be treated as two digits for the purpose of determining the appropriate code set.
=end
    it "should minimize symbol length according to GS1-128 guidelines" do
      # Determine the Start Character.
      assert_equal "#{CODEC}#{FNC1}10", Code128.apply_shortest_encoding_for_data("#{FNC1}10")
      assert_equal "#{CODEC}#{FNC1}101234", Code128.apply_shortest_encoding_for_data("#{FNC1}101234")
      assert_equal "#{CODEA}10\001LOT", Code128.apply_shortest_encoding_for_data("10\001LOT")
      assert_equal "#{CODEB}lot1", Code128.apply_shortest_encoding_for_data("lot1")

      # Switching to codeset B from codeset C
      assert_equal "#{CODEC}#{FNC1}10#{CODEB}1", Code128.apply_shortest_encoding_for_data("#{FNC1}101")
      # Switching to codeset A from codeset C
      assert_equal "#{CODEC}#{FNC1}10#{CODEA}\001#{CODEB}a", Code128.apply_shortest_encoding_for_data("#{FNC1}10\001a")

      # Switching to codeset C from codeset A
      assert_equal "#{CODEC}#{FNC1}10#{CODEA}\001LOT#{CODEC}1234", Code128.apply_shortest_encoding_for_data("#{FNC1}10\001LOT1234")
      assert_equal "#{CODEC}#{FNC1}10#{CODEA}\001LOT1#{CODEC}2345", Code128.apply_shortest_encoding_for_data("#{FNC1}10\001LOT12345")

      # Switching to codeset C from codeset B
      assert_equal "#{CODEC}#{FNC1}10#{CODEB}LOT#{CODEC}1234", Code128.apply_shortest_encoding_for_data("#{FNC1}10LOT1234")
      assert_equal "#{CODEC}#{FNC1}10#{CODEB}LOT1#{CODEC}2345", Code128.apply_shortest_encoding_for_data("#{FNC1}10LOT12345")

      # Switching to codeset A from codeset B
      assert_equal "#{CODEC}#{FNC1}10#{CODEB}lot#{SHIFT}\001a", Code128.apply_shortest_encoding_for_data("#{FNC1}10lot\001a")
      assert_equal "#{CODEC}#{FNC1}10#{CODEB}lot#{CODEA}\001\001", Code128.apply_shortest_encoding_for_data("#{FNC1}10lot\001\001")

      # Switching to codeset B from codeset A
      assert_equal "#{CODEC}#{FNC1}10#{CODEA}\001#{SHIFT}l\001", Code128.apply_shortest_encoding_for_data("#{FNC1}10\001l\001")
      assert_equal "#{CODEC}#{FNC1}10#{CODEA}\001#{CODEB}ll", Code128.apply_shortest_encoding_for_data("#{FNC1}10\001ll")

      # testing "Note 2" from the GS1 specification
      assert_equal "#{CODEC}#{FNC1}10#{CODEB}LOT#{CODEC}#{FNC1}0101", Code128.apply_shortest_encoding_for_data("#{FNC1}10LOT#{FNC1}0101")
      assert_equal "#{CODEC}#{FNC1}10#{CODEB}LOT#{FNC1}0#{CODEC}1010", Code128.apply_shortest_encoding_for_data("#{FNC1}10LOT#{FNC1}01010")
      assert_equal "#{CODEC}#{FNC1}10#{CODEB}LOT#{CODEC}01#{FNC1}0101", Code128.apply_shortest_encoding_for_data("#{FNC1}10LOT01#{FNC1}0101")
    end

    it "should know how to extract CODEC segments properly from a data string" do
      assert_equal ["1234", "abcd", "5678", "\r\n\r\n"], Code128.send(:extract_codec, "1234abcd5678\r\n\r\n")
      assert_equal ["1234", "5abc6"], Code128.send(:extract_codec, "12345abc6")
      assert_equal ["abcdef"], Code128.send(:extract_codec, "abcdef")
      assert_equal ["123abcdef4", "5678"], Code128.send(:extract_codec, "123abcdef45678")
      assert_equal ["abcd1", "2345"], Code128.send(:extract_codec, "abcd12345")
      assert_equal ["abcd1", "2345", "efg"], Code128.send(:extract_codec, "abcd12345efg")
      assert_equal ["1234", "5"], Code128.send(:extract_codec, "12345")
      assert_equal ["1234", "5abc"], Code128.send(:extract_codec, "12345abc")
      assert_equal ["abcdef1", "234567"], Code128.send(:extract_codec, "abcdef1234567")
    end

    it "should know how to most efficiently apply different encodings to a data string" do
      assert_equal "#{CODEC}123456", Code128.apply_shortest_encoding_for_data("123456")
      assert_equal "#{CODEB}abcdef", Code128.apply_shortest_encoding_for_data("abcdef")
      assert_equal "#{CODEB}ABCDEF", Code128.apply_shortest_encoding_for_data("ABCDEF")
      assert_equal "#{CODEA}\n\t\r", Code128.apply_shortest_encoding_for_data("\n\t\r")
      assert_equal "#{CODEC}123456#{CODEB}abcdef", Code128.apply_shortest_encoding_for_data("123456abcdef")
      assert_equal "#{CODEB}abcdef#{CODEC}123456", Code128.apply_shortest_encoding_for_data("abcdef123456")
      assert_equal "#{CODEC}123456#{CODEB}7", Code128.apply_shortest_encoding_for_data("1234567")
      assert_equal "#{CODEB}123b456", Code128.apply_shortest_encoding_for_data("123b456")
      assert_equal "#{CODEB}abc123def4#{CODEC}5678#{CODEB}gh", Code128.apply_shortest_encoding_for_data("abc123def45678gh")
      assert_equal "#{CODEC}1234#{CODEA}5AB\nEE#{CODEB}asdgr12EE#{CODEA}\r\n", Code128.apply_shortest_encoding_for_data("12345AB\nEEasdgr12EE\r\n")
      assert_equal "#{CODEC}123456#{CODEA}QWERTY\r\n\tAA#{CODEB}bbcc12XX3#{CODEC}4567", Code128.apply_shortest_encoding_for_data("123456QWERTY\r\n\tAAbbcc12XX34567")

      assert_equal "#{CODEB}ABCdef#{SHIFT}\rGHIjkl", Code128.apply_shortest_encoding_for_data("ABCdef\rGHIjkl")
      assert_equal "#{CODEA}ABC\r#{SHIFT}b\nDEF12#{CODEB}gHI#{CODEC}3456", Code128.apply_shortest_encoding_for_data("ABC\rb\nDEF12gHI3456")
      assert_equal "#{CODEB}ABCdef#{SHIFT}\rGHIjkl#{SHIFT}\tMNop#{SHIFT}\nqRs", Code128.apply_shortest_encoding_for_data("ABCdef\rGHIjkl\tMNop\nqRs")
    end

    it "should apply automatic charset when no charset is given" do
      b = Code128.new("123456QWERTY\r\n\tAAbbcc12XX34567")
      assert_equal 'C', b.type
      assert_equal "123456#{CODEA}QWERTY\r\n\tAA#{CODEB}bbcc12XX3#{CODEC}4567", b.full_data_with_change_codes
    end

  end



  private

  def binary_encode_array(datas)
    datas.each { |data| binary_encode(data) }
  end

  def binary_encode(data)
    ruby_19_or_greater? ? data.force_encoding('BINARY') : data
  end

end
