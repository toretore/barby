require 'test_helper'
require 'barby/barcode/code_25'

class Code25Test < Barby::TestCase

  before do
    @data = "1234567"
    @code = Code25.new(@data)
  end

  it "should return the same data it was given" do
    _(@code.data).must_equal @data
  end

  it "should have the expected characters" do
    _(@code.characters).must_equal %w(1 2 3 4 5 6 7)
  end

  it "should have the expected characters_with_checksum" do
    _(@code.characters_with_checksum).must_equal %w(1 2 3 4 5 6 7 0)
  end

  it "should have the expected digits" do
    _(@code.digits).must_equal [1,2,3,4,5,6,7]
  end

  it "should have the expected digits_with_checksum" do
    _(@code.digits_with_checksum).must_equal [1,2,3,4,5,6,7,0]
  end

  it "should have the expected even_and_odd_digits" do
    _(@code.even_and_odd_digits).must_equal [[7,5,3,1], [6,4,2]]
  end

  it "should have the expected start_encoding" do
    _(@code.start_encoding).must_equal '1110111010'
  end

  it "should have the expected stop_encoding" do
    _(@code.stop_encoding).must_equal '111010111'
  end

  it "should have a default narrow_width of 1" do
    _(@code.narrow_width).must_equal 1
  end

  it "should have a default wide_width equal to narrow_width * 3" do
    _(@code.wide_width).must_equal @code.narrow_width * 3
    @code.narrow_width = 2
    _(@code.wide_width).must_equal 6
  end

  it "should have a default space_width equal to narrow_width" do
    _(@code.space_width).must_equal @code.narrow_width
    @code.narrow_width = 23
    _(@code.space_width).must_equal 23
  end

  it "should have the expected digit_encodings" do
    _(@code.digit_encodings).must_equal %w(11101010101110 10111010101110 11101110101010 10101110101110 11101011101010 10111011101010 10101011101110)
  end

  it "should have the expected digit_encodings_with_checksum" do
    _(@code.digit_encodings_with_checksum).must_equal %w(11101010101110 10111010101110 11101110101010 10101110101110 11101011101010 10111011101010 10101011101110 10101110111010)
  end

  it "should have the expected data_encoding" do
    _(@code.data_encoding).must_equal "11101010101110101110101011101110111010101010101110101110111010111010101011101110101010101011101110"
  end

  it "should have the expected checksum" do
    _(@code.checksum).must_equal 0
  end

  it "should have the expected checksum_encoding" do
    _(@code.checksum_encoding).must_equal '10101110111010'
  end

  it "should have the expected encoding" do
    _(@code.encoding).must_equal "111011101011101010101110101110101011101110111010101010101110101110111010111010101011101110101010101011101110111010111"
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
    _ { @code.encoding }.must_raise ArgumentError
    _ { @code.data_encoding }.must_raise ArgumentError
    _ { @code.data_encoding_with_checksum }.must_raise ArgumentError
    _ { @code.digit_encodings }.must_raise ArgumentError
    _ { @code.digit_encodings_with_checksum }.must_raise ArgumentError
  end

  it "should return all characters in sequence on to_s" do
    _(@code.to_s).must_equal @code.characters.join
  end

  it "should include checksum in to_s when include_checksum is true" do
    @code.include_checksum = true
    _(@code.to_s).must_equal @code.characters_with_checksum.join
  end

end
