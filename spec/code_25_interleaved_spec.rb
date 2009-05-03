require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/barcode/code_25_interleaved'
include Barby

describe Code25Interleaved do

  before :each do
    @data = '12345670'
    @code = Code25Interleaved.new(@data)
  end

  it "should have the expected digit_pairs" do
    @code.digit_pairs.should == [[1,2],[3,4],[5,6],[7,0]]
  end

  it "should have the expected digit_encodings" do
    @code.digit_encodings.should == %w(111010001010111000 111011101000101000 111010001110001010 101010001110001110)
  end

  it "should have the expected start_encoding" do
    @code.start_encoding.should == '1010'
  end

  it "should have the expected stop_encoding" do
    @code.stop_encoding.should == '11101'
  end

  it "should have the expected data_encoding" do
    @code.data_encoding.should == "111010001010111000111011101000101000111010001110001010101010001110001110"
  end

  it "should have the expected encoding" do
    @code.encoding.should == "101011101000101011100011101110100010100011101000111000101010101000111000111011101"
  end

  it "should be valid" do
    @code.should be_valid
  end

  it "should return the expected encoding for parameters passed to encoding_for_interleaved" do
    w, n = Code25Interleaved::WIDE, Code25Interleaved::NARROW
    #                              1 2 1 2 1 2 1 2 1 2  digits 1 and 2
    #                              B S B S B S B S B S  bars and spaces
    @code.encoding_for_interleaved(w,n,n,w,n,n,n,n,w,w).should == '111010001010111000'
    #                              3 4 3 4 3 4 3 4 3 4  digits 3 and 4
    #                              B S B S B S B S B S  bars and spaces
    @code.encoding_for_interleaved(w,n,w,n,n,w,n,n,n,w).should == '111011101000101000'
  end

  it "should return all characters in sequence for to_s" do
    @code.to_s.should == @code.characters.join
  end

end

describe "Code25Interleaved with checksum" do


  before :each do
    @data = '1234567'
    @code = Code25Interleaved.new(@data)
    @code.include_checksum = true
  end


  it "should have the expected digit_pairs_with_checksum" do
    @code.digit_pairs_with_checksum.should == [[1,2],[3,4],[5,6],[7,0]]
  end

  it "should have the expected digit_encodings_with_checksum" do
    @code.digit_encodings_with_checksum.should == %w(111010001010111000 111011101000101000 111010001110001010 101010001110001110)
  end

  it "should have the expected data_encoding_with_checksum" do
    @code.data_encoding_with_checksum.should == "111010001010111000111011101000101000111010001110001010101010001110001110"
  end

  it "should have the expected encoding" do
    @code.encoding.should == "101011101000101011100011101110100010100011101000111000101010101000111000111011101"
  end

  it "should be valid" do
    @code.should be_valid
  end

  it "should return all characters including checksum in sequence on to_s" do
    @code.to_s.should ==  @code.characters_with_checksum.join
  end


end

describe "Code25Interleaved with invalid number of digits" do


  before :each do
    @data = '1234567'
    @code = Code25Interleaved.new(@data)
  end

  it "should not be valid" do
    @code.should_not be_valid
  end

  it "should raise ArgumentError on all encoding methods" do
    lambda{ @code.encoding }.should raise_error(ArgumentError)
    lambda{ @code.data_encoding }.should raise_error(ArgumentError)
    lambda{ @code.digit_encodings }.should raise_error(ArgumentError)
  end

  it "should not raise ArgumentError on encoding methods that include checksum" do
    lambda{ b=Code25Interleaved.new(@data); b.include_checksum=true; b.encoding }.should_not raise_error(ArgumentError)
    lambda{ @code.data_encoding_with_checksum }.should_not raise_error(ArgumentError)
    lambda{ @code.digit_encodings_with_checksum }.should_not raise_error(ArgumentError)
  end

end
