require 'barcode'
require 'code_128'
include Barby


describe "Common features" do

  before :each do
    @data = 'ABC123'
    @code = Code128A.new(@data)
  end

  it "should have the expected stop encoding (including termination bar 11)" do
    @code.send(:stop_encoding).should == '1100011101011'
  end

  it "should find the right class for a character A, B or C" do
    @code.send(:class_for, 'A').should == Code128A
    @code.send(:class_for, 'B').should == Code128B
    @code.send(:class_for, 'C').should == Code128C
  end

end


describe "Common features for single encoding" do

  before :each do
    @data = 'ABC123'
    @code = Code128A.new(@data)
  end

  it "should have the same data as when initialized" do
    @code.data.should == @data
  end

  it "should be able to change its data" do
    @code.data = '123ABC'
    @code.data.should == '123ABC'
    @code.data.should_not == @data
  end

  it "should not have an extra" do
    @code.extra.should be_nil
  end

  it "should have empty extra encoding" do
    @code.extra_encoding.should == ''
  end

  it "should have the correct checksum" do
    @code.checksum.should == 66
  end

end


describe "Common features for multiple encodings" do

  before :each do
    @data = 'ABC123€Bdef€C4567'
    @code = Code128A.new(@data)
  end

  it "should have a Code B extra" do
    @code.extra.should be_an_instance_of(Code128B)
  end

  it "should have a valid extra" do
    @code.extra.should be_valid
  end

  it "the extra should also have an extra of type C" do
    @code.extra.extra.should be_an_instance_of(Code128C)
  end

  it "the extra's extra should be valid" do
    @code.extra.extra.should be_valid
  end

  it "should not have more than two extras" do
    @code.extra.extra.extra.should be_nil
  end

  it "should split extra data from string on data assignment" do
    @code.data = '123€Babc'
    @code.data.should == '123'
    @code.extra.should be_an_instance_of(Code128B)
    @code.extra.data.should == 'abc'
  end

  it "should be be able to change its extra" do
    @code.extra = '€C1234'
    @code.extra.should be_an_instance_of(Code128C)
    @code.extra.data.should == '1234'
  end

  it "should split extra data from string on extra assignment" do
    @code.extra = '€B123€C4567'
    @code.extra.should be_an_instance_of(Code128B)
    @code.extra.data.should == '123'
    @code.extra.extra.should be_an_instance_of(Code128C)
    @code.extra.extra.data.should == '4567'
  end

  it "should raise an exception when extra string doesn't start with the special code character" do
    lambda{ @code.extra = '123' }.should raise_error
  end

  it "should have the correct checksum" do
    @code.checksum.should == 84
  end

  it "should have the expected encoding" do
                             #STARTA     A          B          C          1          2          3
    @code.encoding.should == '11010000100101000110001000101100010001000110100111001101100111001011001011100'+
                             #CODEB      d          e          f
                             '10111101110100001001101011001000010110000100'+
                             #CODEC      45         67
                             '101110111101011101100010000101100'+
                             #CHECK=84   STOP
                             '100111101001100011101011'
  end

end


describe "128A" do

  before :each do
    @data = 'ABC123'
    @code = Code128A.new(@data)
  end

  it "should be valid when given valid data" do
    @code.should be_valid
  end

  it "should not be valid when given invalid data" do
    @code.data = 'abc123'
    @code.should_not be_valid
  end

  it "should have the expected characters" do
    @code.characters.should == %w(A B C 1 2 3)
  end

  it "should have the expected start encoding" do
    @code.start_encoding.should == '11010000100'
  end

  it "should have the expected data encoding" do
    @code.data_encoding.should == '101000110001000101100010001000110100111001101100111001011001011100'
  end

  it "should have the expected encoding" do
    @code.encoding.should == '11010000100101000110001000101100010001000110100111001101100111001011001011100100100001101100011101011'
  end

  it "should have the expected checksum encoding" do
    @code.checksum_encoding.should == '10010000110'
  end

end


describe "128B" do

  before :each do
    @data = 'abc123'
    @code = Code128B.new(@data)
  end

  it "should be valid when given valid data" do
    @code.should be_valid
  end

  it "should not be valid when given invalid data" do
    @code.data = 'abc£123'
    @code.should_not be_valid
  end

  it "should have the expected characters" do
    @code.characters.should == %w(a b c 1 2 3)
  end

  it "should have the expected start encoding" do
    @code.start_encoding.should == '11010010000'
  end

  it "should have the expected data encoding" do
    @code.data_encoding.should == '100101100001001000011010000101100100111001101100111001011001011100'
  end

  it "should have the expected encoding" do
    @code.encoding.should == '11010010000100101100001001000011010000101100100111001101100111001011001011100110111011101100011101011'
  end

  it "should have the expected checksum encoding" do
    @code.checksum_encoding.should == '11011101110'
  end

end


describe "128C" do

  before :each do
    @data = '123456'
    @code = Code128C.new(@data)
  end

  it "should be valid when given valid data" do
    @code.should be_valid
  end

  it "should not be valid when given invalid data" do
    @code.data = '123'
    @code.should_not be_valid
    @code.data = 'abc'
    @code.should_not be_valid
  end

  it "should have the expected characters" do
    @code.characters.should == %w(12 34 56)
  end

  it "should have the expected start encoding" do
    @code.start_encoding.should == '11010011100'
  end

  it "should have the expected data encoding" do
    @code.data_encoding.should == '101100111001000101100011100010110'
  end

  it "should have the expected encoding" do
    @code.encoding.should == '11010011100101100111001000101100011100010110100011011101100011101011'
  end

  it "should have the expected checksum encoding" do
    @code.checksum_encoding.should == '10001101110'
  end

end


describe "Function characters" do

  it "should retain the special symbols in the data accessor" do
    Code128A.new('€1ABC€2DEF').data.should == '€1ABC€2DEF'
    Code128B.new('€1ABC€2DEF').data.should == '€1ABC€2DEF'
    Code128C.new('€1123456').data.should == '€1123456'
    Code128C.new('12€134€156').data.should == '12€134€156'
  end

  it "should replace special string sequences with their FNC characters in the characters accessor" do
    Code128A.new('€1ABC€2DEF').characters.should == %w(FNC1 A B C FNC2 D E F)
    Code128B.new('€1ABC€2DEF').characters.should == %w(FNC1 A B C FNC2 D E F)
    Code128C.new('€1123456').characters.should == %w(FNC1 12 34 56)
    Code128C.new('12€134€156').characters.should == %w(12 FNC1 34 FNC1 56)
  end

  it "should not allow FNC > 1 for Code C" do
    lambda{ Code128C.new('12€2') }.should raise_error
    lambda{ Code128C.new('12€3') }.should raise_error
    lambda{ Code128C.new('12€4') }.should raise_error
  end

end


describe "Code128 with type" do

  it "should raise an exception when not given a type" do
    lambda{ Code128.new('abc') }.should raise_error(ArgumentError)
  end

  it "should raise an exception when given a non-existent type" do
    lambda{ Code128.new('abc', 'F') }.should raise_error(ArgumentError)
  end

  it "should give the right encoding for type A" do
    code = Code128.new('ABC123', 'A')
    code.encoding.should == '11010000100101000110001000101100010001000110100111001101100111001011001011100100100001101100011101011'
  end

  it "should give the right encoding for type B" do
    code = Code128.new('abc123', 'B')
    code.encoding.should == '11010010000100101100001001000011010000101100100111001101100111001011001011100110111011101100011101011'
  end

  it "should give the right encoding for type B" do
    code = Code128.new('123456', 'C')
    code.encoding.should == '11010011100101100111001000101100011100010110100011011101100011101011'
  end

end
