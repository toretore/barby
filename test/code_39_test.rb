#encoding: ASCII
require 'test_helper'
require 'barby/barcode/code_39'

class Code39Test < Barby::TestCase

  before do
    @data = 'TEST8052'
    @code = Code39.new(@data)
    @code.spacing = 3
  end

  it "should yield self on initialize" do
    c1 = nil
    c2 = Code39.new('TEST'){|c| c1 = c }
    assert_equal c2, c1
  end

  it "should have the expected data" do
    assert_equal @data, @code.data
  end

  it "should have the expected characters" do
    assert_equal @data.split(//), @code.characters
  end

  it "should have the expected start_encoding" do
    assert_equal '100101101101', @code.start_encoding
  end

  it "should have the expected stop_encoding" do
    assert_equal '100101101101', @code.stop_encoding
  end

  it "should have the expected spacing_encoding" do
    assert_equal '000', @code.spacing_encoding
  end

  it "should have the expected encoded characters" do
    assert_equal %w(101011011001 110101100101 101101011001 101011011001 110100101101 101001101101 110100110101 101100101011), @code.encoded_characters
  end

  it "should have the expected data_encoding" do
    assert_equal '101011011001000110101100101000101101011001000101011011001000110100101101000101001101101000110100110101000101100101011', @code.data_encoding
  end

  it "should have the expected encoding" do
    assert_equal '100101101101000101011011001000110101100101000101101011001000101011011001000110100101101000101001101101000110100110101000101100101011000100101101101', @code.encoding
  end

  it "should be valid" do
    assert @code.valid?
  end

  it "should not be valid" do
    @code.data = "123\200456"
    refute @code.valid?
  end

  it "should raise an exception when data is not valid on initialization" do
    assert_raises ArgumentError do
      Code39.new('abc')
    end
  end

  it "should return all characters in sequence without checksum on to_s" do
    assert_equal @data, @code.to_s
  end

  describe "Checksumming" do

    before do
      @code = Code39.new('CODE39')
    end

    it "should have the expected checksum" do
      assert_equal 32, @code.checksum
    end

    it "should have the expected checksum_character" do
      assert_equal 'W', @code.checksum_character
    end

    it "should have the expected checksum_encoding" do
      assert_equal '110011010101', @code.checksum_encoding
    end

    it "should have the expected characters_with_checksum" do
      assert_equal %w(C O D E 3 9 W), @code.characters_with_checksum
    end

    it "should have the expected encoded_characters_with_checksum" do
      assert_equal %w(110110100101 110101101001 101011001011 110101100101 110110010101 101100101101 110011010101), @code.encoded_characters_with_checksum
    end

    it "should have the expected data_encoding_with_checksum" do
      assert_equal "110110100101011010110100101010110010110110101100101011011001010101011001011010110011010101", @code.data_encoding_with_checksum
    end

    it "should have the expected encoding_with_checksum" do
      assert_equal "10010110110101101101001010110101101001010101100101101101011001010110110010101010110010110101100110101010100101101101", @code.encoding_with_checksum
    end

    it "should return the encoding with checksum when include_checksum == true" do
      @code.include_checksum = true
      assert_equal "10010110110101101101001010110101101001010101100101101101011001010110110010101010110010110101100110101010100101101101", @code.encoding
    end

  end

  describe "Normal encoding" do

    before do
      @data = 'ABC$%'
      @code = Code39.new(@data)
    end

    it "should have the expected characters" do
      assert_equal %w(A B C $ %), @code.characters
    end

    it "should have the expected encoded_characters" do
      assert_equal %w(110101001011 101101001011 110110100101 100100100101 101001001001), @code.encoded_characters
    end

    it "should have the expected data_encoding" do
      assert_equal '1101010010110101101001011011011010010101001001001010101001001001', @code.data_encoding
    end

    it "should not be valid" do
      @code.data = 'abc'
      refute @code.valid?
    end

  end

  describe "Extended encoding" do

    before do
      @data = '<abc>'
      @code = Code39.new(@data, true)
    end

    it "should return true on extended?" do
      assert @code.extended?
    end

    it "should have the expected characters" do
      assert_equal %w(% G + A + B + C % I), @code.characters
    end

    it "should have the expected encoded_characters" do
      assert_equal %w(101001001001 101010011011 100101001001 110101001011 100101001001 101101001011 100101001001 110110100101 101001001001 101101001101), @code.encoded_characters
    end

    it "should have the expected data_encoding" do
      assert_equal '101001001001010101001101101001010010010110101001011010010100100101011010010110100101001001011011010010101010010010010101101001101', @code.data_encoding
    end

    it "should have the expected encoding" do
      assert_equal '10010110110101010010010010101010011011010010100100101101010010110100101001001'+
                   '010110100101101001010010010110110100101010100100100101011010011010100101101101',
                   @code.encoding
    end

    it "should take a second parameter on initialize indicating it is extended" do
      assert Code39.new('abc', true).extended?
      refute Code39.new('ABC', false).extended?
      refute Code39.new('ABC').extended?
    end

    it "should be valid" do
      assert @code.valid?
    end

    it "should not be valid" do
      @code.data = "abc\200123"
      refute @code.valid?
    end

    it "should return all characters in sequence without checksum on to_s" do
      assert_equal @data, @code.to_s
    end

  end

  describe "Variable widths" do

    before do
      @data = 'ABC$%'
      @code = Code39.new(@data)
      @code.narrow_width = 2
      @code.wide_width = 5
    end

    it "should have the expected encoded_characters" do
      assert_equal %w(111110011001100000110011111 110011111001100000110011111 111110011111001100000110011 110000011000001100000110011 110011000001100000110000011), @code.encoded_characters
    end

    it "should have the expected data_encoding" do
      #                              A                          SB                          SC                          S$                          S%
      assert_equal '1111100110011000001100111110110011111001100000110011111011111001111100110000011001101100000110000011000001100110110011000001100000110000011', @code.data_encoding

      @code.spacing = 3
      #                              A                          S  B                          S  C                          S  $                          S  %
      assert_equal '111110011001100000110011111000110011111001100000110011111000111110011111001100000110011000110000011000001100000110011000110011000001100000110000011', @code.data_encoding
    end

  end

end


