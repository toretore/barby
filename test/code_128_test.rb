# encoding: UTF-8
require 'test_helper'
require 'barby/barcode/code_128'

class Code128Test < Barby::TestCase

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

    it "should raise an exception when not given a type" do
      lambda{ Code128.new('abc') }.must_raise(ArgumentError)
    end

    it "should raise an exception when given a non-existent type" do
      lambda{ Code128.new('abc', 'F') }.must_raise(ArgumentError)
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


  private
  
  def binary_encode_array(datas)
    datas.each { |data| binary_encode(data) }
  end
  
  def binary_encode(data)
    ruby_19_or_greater? ? data.force_encoding('BINARY') : data
  end
  
end

