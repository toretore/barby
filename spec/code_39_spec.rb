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

  it "should raise an exception when data is not valid on initialization" do
    lambda{ Code39.new('abc') }.should raise_error(ArgumentError)
  end

end


describe "Normal encoding" do

  before :each do
    @data = 'ABC$%'
    @code = Code39.new(@data)
  end

  it "should have the expected characters" do
    @code.characters.should == %w(A B C $ %)
  end

  it "should have the expected encoded_characters" do
    @code.encoded_characters.should == %w(110101001011 101101001011 110110100101 100100100101 101001001001)
  end

  it "should have the expected data_encoding" do
    @code.data_encoding.should == '1101010010110101101001011011011010010101001001001010101001001001'
  end

  it "should not be valid" do
    @code.data = 'abc'
    @code.should_not be_valid
  end

end


describe "Extended encoding" do

  before :each do
    @data = '<abc>'
    @code = Code39.new(@data, true)
  end

  it "should return true on extended?" do
    @code.should be_extended
  end

  it "should have the expected characters" do
    @code.characters.should == %w(% G + A + B + C % I)
  end

  it "should have the expected encoded_characters" do
    @code.encoded_characters.should == %w(101001001001 101010011011 100101001001 110101001011 100101001001 101101001011 100101001001 110110100101 101001001001 101101001101)
  end

  it "should have the expected data_encoding" do
    @code.data_encoding.should == '101001001001010101001101101001010010010110101001011010010100100101011010010110100101001001011011010010101010010010010101101001101'
  end

  it "should have the expected encoding" do
    @code.encoding.should == '10010110110101010010010010101010011011010010100100101101010010110100101001001'+
                             '010110100101101001010010010110110100101010100100100101011010011010100101101101'
  end

  it "should take a second parameter on initialize indicating it is extended" do
    Code39.new('abc', true).should be_extended
    Code39.new('ABC', false).should_not be_extended
    Code39.new('ABC').should_not be_extended
  end

  it "should be valid" do
    @code.should be_valid
  end

  it "should not be valid" do
    @code.data = "abc\200123"
    @code.should_not be_valid
  end

end
