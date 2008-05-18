require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/barcode/bookland'
include Barby

describe Bookland do

  before :each do
    @isbn = '968-26-1240-3'
    @code = Bookland.new(@isbn)
  end

  it "should not touch the ISBN" do
    @code.isbn.should == @isbn
  end

  it "should have an isbn_only" do
    @code.isbn_only.should == '968261240'
  end

  it "should have the expected data" do
    @code.data.should == '978968261240'
  end

  it "should have the expected numbers" do
    @code.numbers.should == [9,7,8,9,6,8,2,6,1,2,4,0]
  end

  it "should have the expected checksum" do
    @code.checksum.should == 4
  end

  it "should raise an error when data not valid" do
    lambda{ Bookland.new('1234') }.should raise_error(ArgumentError)
  end

end


describe Bookland, 'ISBN conversion' do

  it "should accept ISBN with number system and check digit" do
    code = nil
    lambda{ code = Bookland.new('978-82-92526-14-9') }.should_not raise_error
    code.should be_valid
    code.data.should == '978829252614'
  end

  it "should accept ISBN without number system but with check digit" do
    code = nil
    lambda{ code = Bookland.new('82-92526-14-9') }.should_not raise_error
    code.should be_valid
    code.data.should == '978829252614'
  end

  it "should accept ISBN without number system or check digit" do
    code = nil
    lambda{ code = Bookland.new('82-92526-14') }.should_not raise_error
    code.should be_valid
    code.data.should == '978829252614'
  end

end
