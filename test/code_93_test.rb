#encoding: ASCII
require 'test_helper'
require 'barby/barcode/code_93'

class Code93Test < Barby::TestCase

  before do
    @data = 'TEST93'
    @code = Code93.new(@data)
  end

  it "should return the same data we put in" do
    assert_equal @data, @code.data
  end

  it "should have the expected characters" do
    assert_equal @data.split(//), @code.characters
  end

  it "should have the expected start_encoding" do
    assert_equal '101011110', @code.start_encoding
  end

  it "should have the expected stop_encoding" do
    #                              STOP     TERM
    assert_equal '1010111101', @code.stop_encoding
  end

  it "should have the expected encoded characters" do
    #                                     T         E         S         T         9         3
    assert_equal %w(110100110 110010010 110101100 110100110 100001010 101000010), @code.encoded_characters
  end

  it "should have the expected data_encoding" do
    #                              T        E        S        T        9        3
    assert_equal "110100110110010010110101100110100110100001010101000010", @code.data_encoding
  end

  it "should have the expected data_encoding_with_checksums" do
    #                                             T        E        S        T        9        3        + (C)    6 (K)
    assert_equal "110100110110010010110101100110100110100001010101000010101110110100100010", @code.data_encoding_with_checksums
  end

  it "should have the expected encoding" do
    #                         START    T        E        S        T        9        3        + (C)    6 (K)    STOP     TERM
    assert_equal "1010111101101001101100100101101011001101001101000010101010000101011101101001000101010111101", @code.encoding
  end

  it "should have the expected checksum_values" do
    assert_equal [29, 14, 28, 29, 9, 3].reverse, @code.checksum_values #!
  end

  it "should have the expected c_checksum" do
    assert_equal 41, #calculate this first!
      @code.c_checksum
  end

  it "should have the expected c_checksum_character" do
    assert_equal '+', @code.c_checksum_character
  end

  it "should have the expected c_checksum_encoding" do
    assert_equal '101110110', @code.c_checksum_encoding
  end

  it "should have the expected checksum_values_with_c_checksum" do
    assert_equal [29, 14, 28, 29, 9, 3, 41].reverse, @code.checksum_values_with_c_checksum #!
  end

  it "should have the expected k_checksum" do
    assert_equal 6, #calculate this first!
      @code.k_checksum
  end

  it "should have the expected k_checksum_character" do
    assert_equal '6', @code.k_checksum_character
  end

  it "should have the expected k_checksum_encoding" do
    assert_equal '100100010', @code.k_checksum_encoding
  end

  it "should have the expected checksums" do
    assert_equal [41, 6], @code.checksums
  end

  it "should have the expected checksum_characters" do
    assert_equal ['+', '6'], @code.checksum_characters
  end

  it "should have the expected checksum_encodings" do
    assert_equal %w(101110110 100100010), @code.checksum_encodings
  end

  it "should have the expected checksum_encoding" do
    assert_equal '101110110100100010', @code.checksum_encoding
  end

  it "should be valid" do
    assert @code.valid?
  end

  it "should not be valid when not in extended mode" do
    @code.data = 'not extended'
  end

  it "should return data with no checksums on to_s" do
    assert_equal 'TEST93', @code.to_s
  end

  describe "Extended mode" do

    before do
      @data = "Extended!"
      @code = Code93.new(@data)
    end

    it "should be extended" do
      assert @code.extended?
    end

    it "should convert extended characters to special shift characters" do
      assert_equal ["E", "\304", "X", "\304", "T", "\304", "E", "\304", "N", "\304", "D", "\304", "E", "\304", "D", "\303", "A"], @code.characters
    end

    it "should have the expected data_encoding" do
      assert_equal '110010010100110010101100110100110010110100110100110010110010010'+
                   '100110010101000110100110010110010100100110010110010010100110010110010100111010110110101000',
                   @code.data_encoding
    end

    it "should have the expected c_checksum" do
      assert_equal 9, @code.c_checksum
    end

    it "should have the expected k_checksum" do
      assert_equal 46, @code.k_checksum
    end

    it "should return the original data on to_s with no checksums" do
      assert_equal 'Extended!', @code.to_s
    end

  end

end

