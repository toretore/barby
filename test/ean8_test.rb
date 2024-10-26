require 'test_helper'
require 'barby/barcode/ean_8'

class EAN8Test < Barby::TestCase

  describe 'validations' do

    before do
      @valid = EAN8.new('1234567')
    end

    it "should be valid with 7 digits" do
      assert @valid.valid?
    end

    it "should not be valid with less than 7 digits" do
      @valid.data = '123456'
      refute @valid.valid?
    end

    it "should not be valid with more than 7 digits" do
      @valid.data = '12345678'
      refute @valid.valid?
    end

    it "should not be valid with non-digits" do
      @valid.data = 'abcdefg'
      refute @valid.valid?
    end

  end

  describe 'checksum' do

    before :each do
      @code = EAN8.new('5512345')
    end

    it "should have the expected weighted_sum" do
      assert_equal 53, @code.weighted_sum
    end

    it "should have the expected checksum" do
      assert_equal 7, @code.checksum
    end

  end

  describe 'data' do

    before :each do
      @data = '5512345'
      @code = EAN8.new(@data)
    end

    it "should have the expected data" do
      assert_equal @data, @code.data
    end

    it "should have the expected odd_and_even_numbers" do
      assert_equal [[5,3,1,5],[4,2,5]], @code.odd_and_even_numbers
    end

    it "should have the expected left_numbers" do
      #EAN-8 includes the first character in the left-hand encoding, unlike EAN-13
      assert_equal [5,5,1,2], @code.left_numbers
    end

    it "should have the expected right_numbers" do
      assert_equal [3,4,5,7], @code.right_numbers
    end

    it "should return the data with checksum on to_s" do
      assert_equal '55123457', @code.to_s
    end

  end

  describe 'encoding' do

    before :each do
      @code = EAN8.new('5512345')
    end

    it "should have the expected left_parity_map" do
      assert_equal [:odd, :odd, :odd, :odd], @code.left_parity_map
    end

    it "should have the expected left_encoding" do
      assert_equal '0110001011000100110010010011', @code.left_encoding
    end

    it "should have the expected right_encoding" do
      assert_equal '1000010101110010011101000100', @code.right_encoding
    end

  end

end

