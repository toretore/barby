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
      lambda{ EAN13.new('123') }.must_raise(ArgumentError)
    end

  end

  describe 'data' do

    before do
      @data = '007567816412'
      @code = EAN13.new(@data)
    end

    it "should have the same data as was passed to it" do
      @code.data.must_equal @data
    end

    it "should have the expected characters" do
      @code.characters.must_equal @data.split(//)
    end

    it "should have the expected numbers" do
      @code.numbers.must_equal @data.split(//).map{|s| s.to_i }
    end

    it "should have the expected odd_and_even_numbers" do
      @code.odd_and_even_numbers.must_equal [[2,4,1,7,5,0], [1,6,8,6,7,0]]
    end

    it "should have the expected left_numbers" do
                                   #0=second number in number system code
      @code.left_numbers.must_equal [0,7,5,6,7,8]
    end

    it "should have the expected right_numbers" do
      @code.right_numbers.must_equal [1,6,4,1,2,5]#5=checksum
    end

    it "should have the expected numbers_with_checksum" do
      @code.numbers_with_checksum.must_equal @data.split(//).map{|s| s.to_i } + [5]
    end

    it "should have the expected data_with_checksum" do
      @code.data_with_checksum.must_equal @data+'5'
    end

    it "should return all digits and the checksum on to_s" do
      @code.to_s.must_equal '0075678164125'
    end

  end

  describe 'checksum' do

    before do
      @code = EAN13.new('007567816412')
    end

    it "should have the expected weighted_sum" do
      @code.weighted_sum.must_equal 85
      @code.data = '007567816413'
      @code.weighted_sum.must_equal 88
    end

    it "should have the correct checksum" do
      @code.checksum.must_equal 5
      @code.data = '007567816413'
      @code.checksum.must_equal 2
    end

    it "should have the correct checksum_encoding" do
      @code.checksum_encoding.must_equal '1001110'
    end

  end

  describe 'encoding' do

    before do
      @code = EAN13.new('750103131130')
    end

    it "should have the expected checksum" do
      @code.checksum.must_equal 9
    end

    it "should have the expected checksum_encoding" do
      @code.checksum_encoding.must_equal '1110100'
    end

    it "should have the expected left_parity_map" do
      @code.left_parity_map.must_equal [:odd, :even, :odd, :even, :odd, :even]
    end

    it "should have the expected left_encodings" do
      @code.left_encodings.must_equal %w(0110001 0100111 0011001 0100111 0111101 0110011)
    end

    it "should have the expected right_encodings" do
      @code.right_encodings.must_equal %w(1000010 1100110 1100110 1000010 1110010 1110100)
    end

    it "should have the expected left_encoding" do
      @code.left_encoding.must_equal '011000101001110011001010011101111010110011'
    end

    it "should have the expected right_encoding" do
      @code.right_encoding.must_equal '100001011001101100110100001011100101110100'
    end

    it "should have the expected encoding" do
                               #Start   Left                                           Center    Right                                          Stop
      @code.encoding.must_equal '101' + '011000101001110011001010011101111010110011' + '01010' + '100001011001101100110100001011100101110100' + '101'
    end

  end

  describe 'static data' do

    before :each do
      @code = EAN13.new('123456789012')
    end

    it "should have the expected start_encoding" do
      @code.start_encoding.must_equal '101'
    end

    it "should have the expected stop_encoding" do
      @code.stop_encoding.must_equal '101'
    end

    it "should have the expected center_encoding" do
      @code.center_encoding.must_equal '01010'
    end

  end

end

