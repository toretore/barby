require 'test_helper'
require 'barby/barcode/code_25_interleaved'

class Code25InterleavedTest < Barby::TestCase

  before do
    @data = '12345670'
    @code = Code25Interleaved.new(@data)
  end

  it "should have the expected digit_pairs" do
    assert_equal [[1,2],[3,4],[5,6],[7,0]], @code.digit_pairs
  end

  it "should have the expected digit_encodings" do
    assert_equal %w(111010001010111000 111011101000101000 111010001110001010 101010001110001110), @code.digit_encodings
  end

  it "should have the expected start_encoding" do
    assert_equal '1010', @code.start_encoding
  end

  it "should have the expected stop_encoding" do
    assert_equal '11101', @code.stop_encoding
  end

  it "should have the expected data_encoding" do
    assert_equal "111010001010111000111011101000101000111010001110001010101010001110001110", @code.data_encoding
  end

  it "should have the expected encoding" do
    assert_equal "101011101000101011100011101110100010100011101000111000101010101000111000111011101", @code.encoding
  end

  it "should be valid" do
    assert @code.valid?
  end

  it "should return the expected encoding for parameters passed to encoding_for_interleaved" do
    w, n = Code25Interleaved::WIDE, Code25Interleaved::NARROW
    #                              1 2 1 2 1 2 1 2 1 2  digits 1 and 2
    #                              B S B S B S B S B S  bars and spaces
    assert_equal '111010001010111000', @code.encoding_for_interleaved(w,n,n,w,n,n,n,n,w,w)
    #                              3 4 3 4 3 4 3 4 3 4  digits 3 and 4
    #                              B S B S B S B S B S  bars and spaces
    assert_equal '111011101000101000', @code.encoding_for_interleaved(w,n,w,n,n,w,n,n,n,w)
  end

  it "should return all characters in sequence for to_s" do
    assert_equal @code.characters.join, @code.to_s
  end

  describe "with checksum" do

    before do
      @data = '1234567'
      @code = Code25Interleaved.new(@data)
      @code.include_checksum = true
    end

    it "should have the expected digit_pairs_with_checksum" do
      assert_equal [[1,2],[3,4],[5,6],[7,0]], @code.digit_pairs_with_checksum
    end

    it "should have the expected digit_encodings_with_checksum" do
      assert_equal %w(111010001010111000 111011101000101000 111010001110001010 101010001110001110), @code.digit_encodings_with_checksum
    end

    it "should have the expected data_encoding_with_checksum" do
      assert_equal "111010001010111000111011101000101000111010001110001010101010001110001110", @code.data_encoding_with_checksum
    end

    it "should have the expected encoding" do
      assert_equal "101011101000101011100011101110100010100011101000111000101010101000111000111011101", @code.encoding
    end

    it "should be valid" do
      assert @code.valid?
    end

    it "should return all characters including checksum in sequence on to_s" do
      assert_equal  @code.characters_with_checksum.join, @code.to_s
    end

  end

  describe "with invalid number of digits" do

    before do
      @data = '1234567'
      @code = Code25Interleaved.new(@data)
    end

    it "should not be valid" do
      refute @code.valid?
    end

    it "should raise ArgumentError on all encoding methods" do
      assert_raises ArgumentError do
        @code.encoding
      end
      assert_raises ArgumentError do
        @code.data_encoding
      end
      assert_raises ArgumentError do
        @code.digit_encodings
      end
    end

    it "should not raise ArgumentError on encoding methods that include checksum" do
      b = Code25Interleaved.new(@data)
      b.include_checksum = true
      b.encoding
      @code.data_encoding_with_checksum
      @code.digit_encodings_with_checksum
    end

  end

end


