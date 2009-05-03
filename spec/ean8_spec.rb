require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/barcode/ean_8'
include Barby

describe EAN8, 'validations' do

  before :each do
    @valid = EAN8.new('1234567')
  end

  it "should be valid with 7 digits" do
    @valid.should be_valid
  end

  it "should not be valid with less than 7 digits" do
    @valid.data = '123456'
    @valid.should_not be_valid
  end

  it "should not be valid with more than 7 digits" do
    @valid.data = '12345678'
    @valid.should_not be_valid
  end

  it "should not be valid with non-digits" do
    @valid.data = 'abcdefg'
    @valid.should_not be_valid
  end

end


describe EAN8, 'checksum' do

  before :each do
    @code = EAN8.new('5512345')
  end

  it "should have the expected weighted_sum" do
    @code.weighted_sum.should == 53
  end

  it "should have the expected checksum" do
    @code.checksum.should == 7
  end

end


describe EAN8, 'data' do

  before :each do
    @data = '5512345'
    @code = EAN8.new(@data)
  end

  it "should have the expected data" do
    @code.data.should == @data
  end

  it "should have the expected odd_and_even_numbers" do
    @code.odd_and_even_numbers.should == [[5,3,1,5],[4,2,5]]
  end

  it "should have the expected left_numbers" do
    #EAN-8 includes the first character in the left-hand encoding, unlike EAN-13
    @code.left_numbers.should == [5,5,1,2]
  end

  it "should have the expected right_numbers" do
    @code.right_numbers.should == [3,4,5,7]
  end

  it "should return the data with checksum on to_s" do
    @code.to_s.should == '55123457'
  end

end


describe EAN8, 'encoding' do

  before :each do
    @code = EAN8.new('5512345')
  end

  it "should have the expected left_parity_map" do
    @code.left_parity_map.should == [:odd, :odd, :odd, :odd]
  end

  it "should have the expected left_encoding" do
    @code.left_encoding.should == '0110001011000100110010010011'
  end

  it "should have the expected right_encoding" do
    @code.right_encoding.should == '1000010101110010011101000100'
  end

end
