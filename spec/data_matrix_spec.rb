require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/barcode/data_matrix'


describe Barby::DataMatrix do

  before :each do
    @data = "humbaba"
    @code = Barby::DataMatrix.new(@data)
  end

  it "should have the expected encoding" do
    @code.encoding.should == ["1010101010101010", "1011111000011111", "1110111000010100",
                              "1110100100000111", "1101111010101000", "1101111011110011",
                              "1111111100000100", "1100101111110001", "1001000010001010",
                              "1101010110111011", "1000000100011110", "1001010010000011",
                              "1101100111011110", "1110111010000101", "1110010110001010",
                              "1111111111111111"]
  end

  it "should return data on to_s" do
    @code.to_s.should == @data
  end

  it "should be able to change its data" do
    prev_encoding = @code.encoding
    @code.data = "after eight"
    @code.encoding.should_not == prev_encoding
  end

end
