require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/barcode/ean_13'
include Barby

describe EAN13, ' validations' do

  before :each do
    @valid = EAN13.new('123456789012')
  end

  it "should be valid with 12 digits" do
    @valid.should be_valid
  end

  it "should not be valid with non-digit characters" do
    @valid.data = "The shit apple doesn't fall far from the shit tree"
    @valid.should_not be_valid
  end

  it "should not be valid with less than 12 digits" do
    @valid.data = "12345678901"
    @valid.should_not be_valid
  end

  it "should not be valid with more than 12 digits" do
    @valid.data = "1234567890123"
    @valid.should_not be_valid
  end

  it "should raise an exception when data is invalid" do
    lambda{ EAN13.new('123') }.should raise_error(ArgumentError)
  end

end


describe EAN13, ' data' do

  before :each do
    @data = '007567816412'
    @code = EAN13.new(@data)
  end

  it "should have the same data as was passed to it" do
    @code.data.should == @data
  end

  it "should have the expected characters" do
    @code.characters.should == @data.split(//)
  end

  it "should have the expected numbers" do
    @code.numbers.should == @data.split(//).map{|s| s.to_i }
  end

  it "should have the expected odd_and_even_numbers" do
    @code.odd_and_even_numbers.should == [[2,4,1,7,5,0], [1,6,8,6,7,0]]
  end

  it "should have the expected left_numbers" do
                                 #0=second number in number system code
    @code.left_numbers.should == [0,7,5,6,7,8]
  end

  it "should have the expected right_numbers" do
    @code.right_numbers.should == [1,6,4,1,2,5]#5=checksum
  end

  it "should have the expected numbers_with_checksum" do
    @code.numbers_with_checksum.should == @data.split(//).map{|s| s.to_i } + [5]
  end

  it "should have the expected data_with_checksum" do
    @code.data_with_checksum.should == @data+'5'
  end

  it "should return all digits and the checksum on to_s" do
    @code.to_s.should == '0075678164125'
  end

end


describe EAN13, ' checksum' do

  before :each do
    @code = EAN13.new('007567816412')
  end

  it "should have the expected weighted_sum" do
    @code.weighted_sum.should == 85
    @code.data = '007567816413'
    @code.weighted_sum.should == 88
  end

  it "should have the correct checksum" do
    @code.checksum.should == 5
    @code.data = '007567816413'
    @code.checksum.should == 2
  end

  it "should have the correct checksum_encoding" do
    @code.checksum_encoding.should == '1001110'
  end

end


describe EAN13, ' encoding' do

  before :each do
    @code = EAN13.new('750103131130')
  end

  it "should have the expected checksum" do
    @code.checksum.should == 9
  end

  it "should have the expected checksum_encoding" do
    @code.checksum_encoding.should == '1110100'
  end

  it "should have the expected left_parity_map" do
    @code.left_parity_map.should == [:odd, :even, :odd, :even, :odd, :even]
  end

  it "should have the expected left_encodings" do
    @code.left_encodings.should == %w(0110001 0100111 0011001 0100111 0111101 0110011)
  end

  it "should have the expected right_encodings" do
    @code.right_encodings.should == %w(1000010 1100110 1100110 1000010 1110010 1110100)
  end

  it "should have the expected left_encoding" do
    @code.left_encoding.should == '011000101001110011001010011101111010110011'
  end

  it "should have the expected right_encoding" do
    @code.right_encoding.should == '100001011001101100110100001011100101110100'
  end

  it "should have the expected encoding" do
                             #Start   Left                                           Center    Right                                          Stop
    @code.encoding.should == '101' + '011000101001110011001010011101111010110011' + '01010' + '100001011001101100110100001011100101110100' + '101'
  end

end


describe EAN13, 'static data' do

  before :each do
    @code = EAN13.new('123456789012')
  end

  it "should have the expected start_encoding" do
    @code.start_encoding.should == '101'
  end

  it "should have the expected stop_encoding" do
    @code.stop_encoding.should == '101'
  end

  it "should have the expected center_encoding" do
    @code.center_encoding.should == '01010'
  end

end
