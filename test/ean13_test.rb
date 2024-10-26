require 'test_helper'
require 'barby/barcode/ean_13'

class EAN13Test < Barby::TestCase

  describe 'validations' do

    before do
      @valid = EAN13.new('123456789012')
    end

    it "should be valid with 12 digits" do
      assert @valid.valid?
    end

    it "should not be valid with non-digit characters" do
      @valid.data = "The shit apple doesn't fall far from the shit tree"
      refute @valid.valid?
    end

    it "should not be valid with less than 12 digits" do
      @valid.data = "12345678901"
      refute @valid.valid?
    end

    it "should not be valid with more than 12 digits" do
      @valid.data = "1234567890123"
      refute @valid.valid?
    end

    it "should raise an exception when data is invalid" do
      assert_raises ArgumentError do
        EAN13.new('123')
      end
    end

  end

  describe 'data' do

    before do
      @data = '007567816412'
      @code = EAN13.new(@data)
    end

    it "should have the same data as was passed to it" do
      assert_equal @data, @code.data
    end

    it "should have the expected characters" do
      assert_equal @data.split(//), @code.characters
    end

    it "should have the expected numbers" do
      assert_equal @data.split(//).map{|s| s.to_i }, @code.numbers
    end

    it "should have the expected odd_and_even_numbers" do
      assert_equal [[2,4,1,7,5,0], [1,6,8,6,7,0]], @code.odd_and_even_numbers
    end

    it "should have the expected left_numbers" do
      #             0=second number in number system code
      assert_equal [0,7,5,6,7,8], @code.left_numbers
    end

    it "should have the expected right_numbers" do
      #                       5=checksum
      assert_equal [1,6,4,1,2,5], @code.right_numbers
    end

    it "should have the expected numbers_with_checksum" do
      assert_equal @data.split(//).map{|s| s.to_i } + [5], @code.numbers_with_checksum
    end

    it "should have the expected data_with_checksum" do
      assert_equal @data+'5', @code.data_with_checksum
    end

    it "should return all digits and the checksum on to_s" do
      assert_equal '0075678164125', @code.to_s
    end

  end

  describe 'checksum' do

    before do
      @code = EAN13.new('007567816412')
    end

    it "should have the expected weighted_sum" do
      assert_equal 85, @code.weighted_sum
      @code.data = '007567816413'
      assert_equal 88, @code.weighted_sum
    end

    it "should have the correct checksum" do
      assert_equal 5, @code.checksum
      @code.data = '007567816413'
      assert_equal 2, @code.checksum
    end

    it "should have the correct checksum_encoding" do
      assert_equal '1001110', @code.checksum_encoding
    end

  end

  describe 'encoding' do

    before do
      @code = EAN13.new('750103131130')
    end

    it "should have the expected checksum" do
      assert_equal 9, @code.checksum
    end

    it "should have the expected checksum_encoding" do
      assert_equal '1110100', @code.checksum_encoding
    end

    it "should have the expected left_parity_map" do
      assert_equal [:odd, :even, :odd, :even, :odd, :even], @code.left_parity_map
    end

    it "should have the expected left_encodings" do
      assert_equal %w(0110001 0100111 0011001 0100111 0111101 0110011), @code.left_encodings
    end

    it "should have the expected right_encodings" do
      assert_equal %w(1000010 1100110 1100110 1000010 1110010 1110100), @code.right_encodings
    end

    it "should have the expected left_encoding" do
      assert_equal '011000101001110011001010011101111010110011', @code.left_encoding
    end

    it "should have the expected right_encoding" do
      assert_equal '100001011001101100110100001011100101110100', @code.right_encoding
    end

    it "should have the expected encoding" do
      #            Start   Left                                           Center    Right                                          Stop
      assert_equal '101' + '011000101001110011001010011101111010110011' + '01010' + '100001011001101100110100001011100101110100' + '101', @code.encoding
    end

  end

  describe 'static data' do

    before :each do
      @code = EAN13.new('123456789012')
    end

    it "should have the expected start_encoding" do
      assert_equal '101', @code.start_encoding
    end

    it "should have the expected stop_encoding" do
      assert_equal '101', @code.stop_encoding
    end

    it "should have the expected center_encoding" do
      assert_equal '01010', @code.center_encoding
    end

  end

end

