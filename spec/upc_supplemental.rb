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
