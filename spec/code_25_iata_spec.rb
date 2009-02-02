require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/barcode/code_25_iata'
include Barby

describe Code25IATA do

  before :each do
    @data = '0123456789'
    @code = Code25IATA.new(@data)
  end

  it "should have the expected start_encoding" do
    @code.start_encoding.should == '1010'
  end

  it "should have the expected stop_encoding" do
    @code.stop_encoding.should == '11101'
  end

end
