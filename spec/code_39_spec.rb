require File.join(File.dirname(__FILE__), '..', 'code_39')
include Barby

describe Code39 do

  before :each do
    @data = 'TEST8052'
    @code = Code39.new(@data)
    @code.spacing = 3
  end

  it "should have the expected data" do
    @code.data.should == @data
  end

  it "should have the expected characters" do
    @code.characters.should == @data.split(//)
  end

  it "should have the expected start_character" do
    @code.start_character.should == '*'
  end

  it "should have the expected stop_character" do
    @code.stop_character.should == '*'
  end

  it "should have the expected start_encoding" do
    @code.start_encoding.should == '100101101101'
  end

  it "should have the expected stop_encoding" do
    @code.stop_encoding.should == '100101101101'
  end

  it "should have the expected spacing_encoding" do
    @code.spacing_encoding.should == '000'
  end

  it "should have the expected encoded characters" do
    @code.encoded_characters.should == %w(101011011001 110101100101 101101011001 101011011001 110100101101 101001101101 110100110101 101100101011)
  end

  it "should have the expected data_encoding" do
    @code.data_encoding.should == '101011011001000110101100101000101101011001000101011011001000110100101101000101001101101000110100110101000101100101011'
  end

  it "should have the expected encoding" do
    @code.encoding.should == '100101101101000101011011001000110101100101000101101011001000101011011001000110100101101000101001101101000110100110101000101100101011000100101101101'
  end

  it "should be valid" do
    @code.should be_valid
  end

  it "should not be valid" do
    @code.data = "123\200456"
    @code.should_not be_valid
  end

end
