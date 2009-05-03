require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/barcode/gs1_128'
include Barby

describe GS1128 do

  before :each do
    @code = GS1128.new('071230', 'C', '11')
  end

  it "should inherit Code128" do
    GS1128.superclass.should == Code128
  end

  it "should have an application_identifier attribute" do
    @code.should respond_to(:application_identifier)
    @code.should respond_to(:application_identifier=)
  end

  it "should have the given application identifier" do
    @code.application_identifier.should == '11'
  end

  it "should have an application_identifier_encoding" do
    @code.should respond_to(:application_identifier_encoding)
  end

  it "should have the expected application_identifier_number" do
    @code.application_identifier_number.should == 11
  end

  it "should have the expected application identifier encoding" do
    @code.application_identifier_encoding.should == '11000100100'#Code C number 11
  end

  it "should have data with FNC1 and AI" do
    @code.data.should == "\30111071230"
  end

  it "should have partial_data without FNC1 or AI" do
    @code.partial_data.should == '071230'
  end

  it "should have characters that include FNC1 and AI" do
    @code.characters.should == %W(\301 11 07 12 30)
  end

  it "should have data_encoding that includes FNC1 and the AI" do
    @code.data_encoding.should == '1111010111011000100100100110001001011001110011011011000'
  end

  it "should have the expected checksum" do
    @code.checksum.should == 36
  end

  it "should have the expected checksum encoding" do
    @code.checksum_encoding == '10110001000'
  end

  it "should have the expected encoding" do
    @code.encoding.should == '110100111001111010111011000100100100110001001011001110011011011000101100010001100011101011'
  end

  it "should return full data excluding change codes, including AI on to_s" do
    @code.to_s.should == '(11) 071230'
  end

end
