# encoding: UTF-8
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
    @code.send(:stop_encoding).must_equal '1100011101011'
  end

  it "should find the right class for a character A, B or C" do
    @code.send(:class_for, 'A').must_equal Code128A
    @code.send(:class_for, 'B').must_equal Code128B
    @code.send(:class_for, 'C').must_equal Code128C
  end

  it "should find the right change code for a class" do
    @code.send(:change_code_for_class, Code128A).must_equal Code128::CODEA
    @code.send(:change_code_for_class, Code128B).must_equal Code128::CODEB
    @code.send(:change_code_for_class, Code128C).must_equal Code128::CODEC
  end

  it "should not allow empty data" do
    lambda{ Code128B.new("") }.must_raise(ArgumentError)
  end

  describe "single encoding" do

    before do
      @data = 'ABC123'
      @code = Code128A.new(@data)
    end

    it "should have the same data as when initialized" do
      @code.data.must_equal @data
    end

    it "should be able to change its data" do
      @code.data = '123ABC'
      @code.data.must_equal '123ABC'
      @code.data.wont_equal @data
    end

    it "should not have an extra" do
      assert @code.extra.nil?
    end

    it "should have empty extra encoding" do
      @code.extra_encoding.must_equal ''
    end

    it "should have the correct checksum" do
      @code.checksum.must_equal 66
    end

    it "should return all data for to_s" do
      @code.to_s.must_equal @data
    end

  end

  describe "multiple encodings" do

    before do
      @data = binary_encode("ABC123\306def\3074567")
      @code = Code128A.new(@data)
    end

    it "should be able to return full_data which includes the entire extra chain excluding charset change characters" do
      @code.full_data.must_equal "ABC123def4567"
    end

    it "should be able to return full_data_with_change_codes which includes the entire extra chain including charset change characters" do
      @code.full_data_with_change_codes.must_equal @data
    end

    it "should not matter if extras were added separately" do
      code = Code128B.new("ABC")
      code.extra = binary_encode("\3071234")
      code.full_data.must_equal "ABC1234"
      code.full_data_with_change_codes.must_equal binary_encode("ABC\3071234")
      code.extra.extra = binary_encode("\306abc")
      code.full_data.must_equal "ABC1234abc"
      code.full_data_with_change_codes.must_equal binary_encode("ABC\3071234\306abc")
      code.extra.extra.data = binary_encode("abc\305DEF")
      code.full_data.must_equal "ABC1234abcDEF"
      code.full_data_with_change_codes.must_equal binary_encode("ABC\3071234\306abc\305DEF")
      code.extra.extra.full_data.must_equal "abcDEF"
      code.extra.extra.full_data_with_change_codes.must_equal binary_encode("abc\305DEF")
      code.extra.full_data.must_equal "1234abcDEF"
      code.extra.full_data_with_change_codes.must_equal binary_encode("1234\306abc\305DEF")
    end

    it "should have a Code B extra" do
      @code.extra.must_be_instance_of(Code128B)
    end

    it "should have a valid extra" do
      assert @code.extra.valid?
    end

    it "the extra should also have an extra of type C" do
      @code.extra.extra.must_be_instance_of(Code128C)
    end

    it "the extra's extra should be valid" do
      assert @code.extra.extra.valid?
    end

    it "should not have more than two extras" do
      assert @code.extra.extra.extra.nil?
    end

    it "should split extra data from string on data assignment" do
      @code.data = binary_encode("123\306abc")
      @code.data.must_equal '123'
      @code.extra.must_be_instance_of(Code128B)
      @code.extra.data.must_equal 'abc'
    end

    it "should be be able to change its extra" do
      @code.extra = binary_encode("\3071234")
      @code.extra.must_be_instance_of(Code128C)
      @code.extra.data.must_equal '1234'
    end

    it "should split extra data from string on extra assignment" do
      @code.extra = binary_encode("\306123\3074567")
      @code.extra.must_be_instance_of(Code128B)
      @code.extra.data.must_equal '123'
      @code.extra.extra.must_be_instance_of(Code128C)
      @code.extra.extra.data.must_equal '4567'
    end

    it "should not fail on newlines in extras" do
      code = Code128B.new(binary_encode("ABC\305\n"))
      code.data.must_equal "ABC"
      code.extra.must_be_instance_of(Code128A)
      code.extra.data.must_equal "\n"
      code.extra.extra = binary_encode("\305\n\n\n\n\n\nVALID")
      code.extra.extra.data.must_equal "\n\n\n\n\n\nVALID"
    end

    it "should raise an exception when extra string doesn't start with the special code character" do
      lambda{ @code.extra = '123' }.must_raise ArgumentError
    end

    it "should have the correct checksum" do
      @code.checksum.must_equal 84
    end

    it "should have the expected encoding" do
                                #STARTA     A          B          C          1          2          3
      @code.encoding.must_equal '11010000100101000110001000101100010001000110100111001101100111001011001011100'+
                                #CODEB      d          e          f
                                '10111101110100001001101011001000010110000100'+
                                #CODEC      45         67
                                '101110111101011101100010000101100'+
                                #CHECK=84   STOP
                                '100111101001100011101011'
    end

    it "should return all data including extras, except change codes for to_s" do
      @code.to_s.must_equal "ABC123def4567"
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
      @code.characters.must_equal %w(A B C 1 2 3)
    end

    it "should have the expected start encoding" do
      @code.start_encoding.must_equal '11010000100'
    end

    it "should have the expected data encoding" do
      @code.data_encoding.must_equal '101000110001000101100010001000110100111001101100111001011001011100'
    end

    it "should have the expected encoding" do
      @code.encoding.must_equal '11010000100101000110001000101100010001000110100111001101100111001011001011100100100001101100011101011'
    end

    it "should have the expected checksum encoding" do
      @code.checksum_encoding.must_equal '10010000110'
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
      @code.characters.must_equal %w(a b c 1 2 3)
    end

    it "should have the expected start encoding" do
      @code.start_encoding.must_equal '11010010000'
    end

    it "should have the expected data encoding" do
      @code.data_encoding.must_equal '100101100001001000011010000101100100111001101100111001011001011100'
    end

    it "should have the expected encoding" do
      @code.encoding.must_equal '11010010000100101100001001000011010000101100100111001101100111001011001011100110111011101100011101011'
    end

    it "should have the expected checksum encoding" do
      @code.checksum_encoding.must_equal '11011101110'
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
      @code.characters.must_equal %w(12 34 56)
    end

    it "should have the expected start encoding" do
      @code.start_encoding.must_equal '11010011100'
    end

    it "should have the expected data encoding" do
      @code.data_encoding.must_equal '101100111001000101100011100010110'
    end

    it "should have the expected encoding" do
      @code.encoding.must_equal '11010011100101100111001000101100011100010110100011011101100011101011'
    end

    it "should have the expected checksum encoding" do
      @code.checksum_encoding.must_equal '10001101110'
    end

  end

  describe "Function characters" do

    it "should retain the special symbols in the data accessor" do
      Code128A.new(binary_encode("\301ABC\301DEF")).data.must_equal binary_encode("\301ABC\301DEF")
      Code128B.new(binary_encode("\301ABC\302DEF")).data.must_equal binary_encode("\301ABC\302DEF")
      Code128C.new(binary_encode("\301123456")).data.must_equal binary_encode("\301123456")
      Code128C.new(binary_encode("12\30134\30156")).data.must_equal binary_encode("12\30134\30156")
    end

    it "should keep the special symbols as characters" do
      Code128A.new(binary_encode("\301ABC\301DEF")).characters.must_equal binary_encode_array(%W(\301 A B C \301 D E F))
      Code128B.new(binary_encode("\301ABC\302DEF")).characters.must_equal binary_encode_array(%W(\301 A B C \302 D E F))
      Code128C.new(binary_encode("\301123456")).characters.must_equal binary_encode_array(%W(\301 12 34 56))
      Code128C.new(binary_encode("12\30134\30156")).characters.must_equal binary_encode_array(%W(12 \301 34 \301 56))
    end

    it "should not allow FNC > 1 for Code C" do
      lambda{ Code128C.new("12\302") }.must_raise ArgumentError
      lambda{ Code128C.new("\30312") }.must_raise ArgumentError
      lambda{ Code128C.new("12\304") }.must_raise ArgumentError
    end

    it "should be included in the encoding" do
      a = Code128A.new(binary_encode("\301AB"))
      a.data_encoding.must_equal '111101011101010001100010001011000'
      a.encoding.must_equal '11010000100111101011101010001100010001011000101000011001100011101011'
    end

  end

  describe "Code128 with type" do

    #it "should raise an exception when not given a type" do
    #  lambda{ Code128.new('abc') }.must_raise(ArgumentError)
    #end

    it "should raise an exception when given a non-existent type" do
      lambda{ Code128.new('abc', 'F') }.must_raise(ArgumentError)
    end

    it "should not fail on frozen type" do
      Code128.new('123456', 'C'.freeze) # not failing
      Code128.new('123456', 'c'.freeze) # not failing even when upcasing
    end

    it "should give the right encoding for type A" do
      code = Code128.new('ABC123', 'A')
      code.encoding.must_equal '11010000100101000110001000101100010001000110100111001101100111001011001011100100100001101100011101011'
    end

    it "should give the right encoding for type B" do
      code = Code128.new('abc123', 'B')
      code.encoding.must_equal '11010010000100101100001001000011010000101100100111001101100111001011001011100110111011101100011101011'
    end

    it "should give the right encoding for type B" do
      code = Code128.new('123456', 'C')
      code.encoding.must_equal '11010011100101100111001000101100011100010110100011011101100011101011'
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
      Code128.apply_shortest_encoding_for_data("#{FNC1}10").must_equal "#{CODEC}#{FNC1}10"
      Code128.apply_shortest_encoding_for_data("#{FNC1}101234").must_equal "#{CODEC}#{FNC1}101234"
      Code128.apply_shortest_encoding_for_data("10\001LOT").must_equal "#{CODEA}10\001LOT"
      Code128.apply_shortest_encoding_for_data("lot1").must_equal "#{CODEB}lot1"

      # Switching to codeset B from codeset C
      Code128.apply_shortest_encoding_for_data("#{FNC1}101").must_equal "#{CODEC}#{FNC1}10#{CODEB}1"
      # Switching to codeset A from codeset C
      Code128.apply_shortest_encoding_for_data("#{FNC1}10\001a").must_equal "#{CODEC}#{FNC1}10#{CODEA}\001#{CODEB}a"

      # Switching to codeset C from codeset A
      Code128.apply_shortest_encoding_for_data("#{FNC1}10\001LOT1234").must_equal "#{CODEC}#{FNC1}10#{CODEA}\001LOT#{CODEC}1234"
      Code128.apply_shortest_encoding_for_data("#{FNC1}10\001LOT12345").must_equal "#{CODEC}#{FNC1}10#{CODEA}\001LOT1#{CODEC}2345"

      # Switching to codeset C from codeset B
      Code128.apply_shortest_encoding_for_data("#{FNC1}10LOT1234").must_equal "#{CODEC}#{FNC1}10#{CODEB}LOT#{CODEC}1234"
      Code128.apply_shortest_encoding_for_data("#{FNC1}10LOT12345").must_equal "#{CODEC}#{FNC1}10#{CODEB}LOT1#{CODEC}2345"

      # Switching to codeset A from codeset B
      Code128.apply_shortest_encoding_for_data("#{FNC1}10lot\001a").must_equal "#{CODEC}#{FNC1}10#{CODEB}lot#{SHIFT}\001a"
      Code128.apply_shortest_encoding_for_data("#{FNC1}10lot\001\001").must_equal "#{CODEC}#{FNC1}10#{CODEB}lot#{CODEA}\001\001"

      # Switching to codeset B from codeset A
      Code128.apply_shortest_encoding_for_data("#{FNC1}10\001l\001").must_equal "#{CODEC}#{FNC1}10#{CODEA}\001#{SHIFT}l\001"
      Code128.apply_shortest_encoding_for_data("#{FNC1}10\001ll").must_equal "#{CODEC}#{FNC1}10#{CODEA}\001#{CODEB}ll"

      # testing "Note 2" from the GS1 specification
      Code128.apply_shortest_encoding_for_data("#{FNC1}10LOT#{FNC1}0101").must_equal "#{CODEC}#{FNC1}10#{CODEB}LOT#{CODEC}#{FNC1}0101"
      Code128.apply_shortest_encoding_for_data("#{FNC1}10LOT#{FNC1}01010").must_equal "#{CODEC}#{FNC1}10#{CODEB}LOT#{FNC1}0#{CODEC}1010"
      Code128.apply_shortest_encoding_for_data("#{FNC1}10LOT01#{FNC1}0101").must_equal "#{CODEC}#{FNC1}10#{CODEB}LOT#{CODEC}01#{FNC1}0101"
    end

    it "should know how to extract CODEC segments properly from a data string" do
      Code128.send(:extract_codec, "1234abcd5678\r\n\r\n").must_equal ["1234", "abcd", "5678", "\r\n\r\n"]
      Code128.send(:extract_codec, "12345abc6").must_equal ["1234", "5abc6"]
      Code128.send(:extract_codec, "abcdef").must_equal ["abcdef"]
      Code128.send(:extract_codec, "123abcdef45678").must_equal ["123abcdef4", "5678"]
      Code128.send(:extract_codec, "abcd12345").must_equal ["abcd1", "2345"]
      Code128.send(:extract_codec, "abcd12345efg").must_equal ["abcd1", "2345", "efg"]
      Code128.send(:extract_codec, "12345").must_equal ["1234", "5"]
      Code128.send(:extract_codec, "12345abc").must_equal ["1234", "5abc"]
      Code128.send(:extract_codec, "abcdef1234567").must_equal ["abcdef1", "234567"]
    end

    it "should know how to most efficiently apply different encodings to a data string" do
      Code128.apply_shortest_encoding_for_data("123456").must_equal "#{CODEC}123456"
      Code128.apply_shortest_encoding_for_data("abcdef").must_equal "#{CODEB}abcdef"
      Code128.apply_shortest_encoding_for_data("ABCDEF").must_equal "#{CODEB}ABCDEF"
      Code128.apply_shortest_encoding_for_data("\n\t\r").must_equal "#{CODEA}\n\t\r"
      Code128.apply_shortest_encoding_for_data("123456abcdef").must_equal "#{CODEC}123456#{CODEB}abcdef"
      Code128.apply_shortest_encoding_for_data("abcdef123456").must_equal "#{CODEB}abcdef#{CODEC}123456"
      Code128.apply_shortest_encoding_for_data("1234567").must_equal "#{CODEC}123456#{CODEB}7"
      Code128.apply_shortest_encoding_for_data("123b456").must_equal "#{CODEB}123b456"
      Code128.apply_shortest_encoding_for_data("abc123def45678gh").must_equal "#{CODEB}abc123def4#{CODEC}5678#{CODEB}gh"
      Code128.apply_shortest_encoding_for_data("12345AB\nEEasdgr12EE\r\n").must_equal "#{CODEC}1234#{CODEA}5AB\nEE#{CODEB}asdgr12EE#{CODEA}\r\n"
      Code128.apply_shortest_encoding_for_data("123456QWERTY\r\n\tAAbbcc12XX34567").must_equal "#{CODEC}123456#{CODEA}QWERTY\r\n\tAA#{CODEB}bbcc12XX3#{CODEC}4567"

      Code128.apply_shortest_encoding_for_data("ABCdef\rGHIjkl").must_equal "#{CODEB}ABCdef#{SHIFT}\rGHIjkl"
      Code128.apply_shortest_encoding_for_data("ABC\rb\nDEF12gHI3456").must_equal "#{CODEA}ABC\r#{SHIFT}b\nDEF12#{CODEB}gHI#{CODEC}3456"
      Code128.apply_shortest_encoding_for_data("ABCdef\rGHIjkl\tMNop\nqRs").must_equal "#{CODEB}ABCdef#{SHIFT}\rGHIjkl#{SHIFT}\tMNop#{SHIFT}\nqRs"
    end

    it "should apply automatic charset when no charset is given" do
      b = Code128.new("123456QWERTY\r\n\tAAbbcc12XX34567")
      b.type.must_equal 'C'
      b.full_data_with_change_codes.must_equal "123456#{CODEA}QWERTY\r\n\tAA#{CODEB}bbcc12XX3#{CODEC}4567"
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
