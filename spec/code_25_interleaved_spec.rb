require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/barcode/code_25_interleaved'
include Barby

describe Code25Interleaved do

  before :each do
    @data = '12345670'
    @code = Code25Interleaved.new(@data)
  end

  it "should have the expected character_pairs" do
    @code.character_pairs.should == [['1','2'],['3','4'],['5','6'],['7','0']]
  end

  it "should have the expected digit_pairs" do
    @code.digit_pairs.should == [[1,2],[3,4],[5,6],[7,0]]
  end

  it "should have the expected digit_pair_encodings" do
    @code.digit_pair_encodings.should == %w(111010001010111000 111011101000101000 111010001110001010 101010001110001110)
  end

  it "should have the expected checksum" do
    @code.checksum.should == 8
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

end
