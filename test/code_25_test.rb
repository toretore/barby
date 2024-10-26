require 'test_helper'
require 'barby/barcode/code_25'

class Code25Test < Barby::TestCase

  before do
    @data = "1234567"
    @code = Code25.new(@data)
  end

  it "should return the same data it was given" do
    assert_equal @data, @code.data
  end

  it "should have the expected characters" do
    assert_equal %w(1 2 3 4 5 6 7), @code.characters
  end

  it "should have the expected characters_with_checksum" do
    assert_equal %w(1 2 3 4 5 6 7 0), @code.characters_with_checksum
  end

  it "should have the expected digits" do
    assert_equal [1,2,3,4,5,6,7], @code.digits
  end

  it "should have the expected digits_with_checksum" do
    assert_equal [1,2,3,4,5,6,7,0], @code.digits_with_checksum
  end

  it "should have the expected even_and_odd_digits" do
    assert_equal [[7,5,3,1], [6,4,2]], @code.even_and_odd_digits
  end

  it "should have the expected start_encoding" do
    assert_equal '1110111010', @code.start_encoding
  end

  it "should have the expected stop_encoding" do
    assert_equal '111010111', @code.stop_encoding
  end

  it "should have a default narrow_width of 1" do
    assert_equal 1, @code.narrow_width
  end

  it "should have a default wide_width equal to narrow_width * 3" do
    assert_equal @code.narrow_width * 3, @code.wide_width
    @code.narrow_width = 2
    assert_equal 6, @code.wide_width
  end

  it "should have a default space_width equal to narrow_width" do
    assert_equal @code.narrow_width, @code.space_width
    @code.narrow_width = 23
    assert_equal 23, @code.space_width
  end

  it "should have the expected digit_encodings" do
    assert_equal %w(11101010101110 10111010101110 11101110101010 10101110101110 11101011101010 10111011101010 10101011101110), @code.digit_encodings
  end

  it "should have the expected digit_encodings_with_checksum" do
    assert_equal %w(11101010101110 10111010101110 11101110101010 10101110101110 11101011101010 10111011101010 10101011101110 10101110111010), @code.digit_encodings_with_checksum
  end

  it "should have the expected data_encoding" do
    assert_equal "11101010101110101110101011101110111010101010101110101110111010111010101011101110101010101011101110", @code.data_encoding
  end

  it "should have the expected checksum" do
    assert_equal 0, @code.checksum
  end

  it "should have the expected checksum_encoding" do
    assert_equal '10101110111010', @code.checksum_encoding
  end

  it "should have the expected encoding" do
    assert_equal "111011101011101010101110101110101011101110111010101010101110101110111010111010101011101110101010101011101110111010111", @code.encoding
  end

  it "should be valid" do
    assert @code.valid?
  end

  it "should not be valid" do
    @code.data = 'abc'
    refute @code.valid?
  end

  it "should raise on encoding methods that include data encoding if not valid" do
    @code.data = 'abc'
    assert_raises ArgumentError do
      @code.encoding
    end
    assert_raises ArgumentError do
      @code.data_encoding
    end
    assert_raises ArgumentError do
      @code.data_encoding_with_checksum
    end
    assert_raises ArgumentError do
      @code.digit_encodings
    end
    assert_raises ArgumentError do
      @code.digit_encodings_with_checksum
    end
  end

  it "should return all characters in sequence on to_s" do
    assert_equal @code.characters.join, @code.to_s
  end

  it "should include checksum in to_s when include_checksum is true" do
    @code.include_checksum = true
    assert_equal @code.characters_with_checksum.join, @code.to_s
  end

end
