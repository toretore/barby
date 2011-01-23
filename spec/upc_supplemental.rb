require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/barcode/upc_supplemental'
include Barby

describe UPCSupplemental, 'validity' do

  before :each do
    @valid = UPCSupplemental.new('12345')
  end

  it 'should be valid with 5 digits' do
    @valid.should be_valid
  end

  it 'should not be valid with less than 5 digits' do
    UPCSupplemental.new('1234').should_not be_valid
    UPCSupplemental.new('12').should_not be_valid
  end

  it 'should not be valid with more than 5 digits' do
    UPCSupplemental.new('123456').should_not be_valid
    UPCSupplemental.new('123456789012').should_not be_valid
  end

  it 'should not be valid with non-digit characters' do
    UPCSupplemental.new('abcde').should_not be_valid
    UPCSupplemental.new('ABC').should_not be_valid
    UPCSupplemental.new('1234e').should_not be_valid
    UPCSupplemental.new('!2345').should_not be_valid
  end

end


describe UPCSupplemental, 'checksum' do

  it 'should have the expected odd_digits' do
    UPCSupplemental.new('51234').odd_digits.should == [4,2,5]
    UPCSupplemental.new('54321').odd_digits.should == [1,3,5]
    UPCSupplemental.new('99990').odd_digits.should == [0,9,9]
  end

  it 'should have the expected even_digits' do
    UPCSupplemental.new('51234').even_digits.should == [3,1]
    UPCSupplemental.new('54321').even_digits.should == [2,4]
    UPCSupplemental.new('99990').even_digits.should == [9,9]
  end

  it 'should have the expected odd and even sums' do
    UPCSupplemental.new('51234').odd_sum.should == 33
    UPCSupplemental.new('54321').odd_sum.should == 27
    UPCSupplemental.new('99990').odd_sum.should == 54

    UPCSupplemental.new('51234').even_sum.should == 36
    UPCSupplemental.new('54321').even_sum.should == 54
    UPCSupplemental.new('99990').even_sum.should == 162
  end

  it 'should have the expected checksum' do
    UPCSupplemental.new('51234').checksum.should == 9
    UPCSupplemental.new('54321').checksum.should == 1
    UPCSupplemental.new('99990').checksum.should == 6
  end

end


describe UPCSupplemental, 'encoding' do

  before :each do
    @data = '51234'
    @code = UPCSupplemental.new(@data)
  end

  it 'should have the expected encoding' do
    #                        START 5          1          2          3          4
    UPCSupplemental.new('51234').encoding.should == '1011 0110001 01 0011001 01 0011011 01 0111101 01 0011101'.tr(' ', '')
    #                              9          9          9          9          0
    UPCSupplemental.new('99990').encoding.should == '1011 0001011 01 0001011 01 0001011 01 0010111 01 0100111'.tr(' ', '')
  end

  it 'should be able to change its data' do
    prev_encoding = @code.encoding
    @code.data = '99990'
    @code.encoding.should_not == prev_encoding
    #                              9          9          9          9          0
    @code.encoding.should == '1011 0001011 01 0001011 01 0001011 01 0010111 01 0100111'.tr(' ', '')
  end

end
