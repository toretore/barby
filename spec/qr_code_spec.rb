require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/barcode/qr_code'
include Barby


describe QRCode do

  before :each do
    @data = 'Ereshkigal'
    @code = QRCode.new(@data)
  end

  it "should have the expected data" do
    @code.data.should == @data
  end

  it "should have the expected encoding" do
    #Should be an array of strings, where each string
    #represents a "line"
    @code.encoding.should == rqrcode(@code).modules.map do |line|
      line.inject(''){|s,m| s << (m ? '1' : '0') }
    end
  end

  it "should be able to change its data and output a different encoding" do
    @code.data = 'hades'
    @code.data.should == 'hades'
    @code.encoding.should == rqrcode(@code).modules.map do |line|
      line.inject(''){|s,m| s << (m ? '1' : '0') }
    end
  end

  it "should have a 'level' accessor" do
    @code.should respond_to(:level)
    @code.should respond_to(:level=)
  end

  it "should set size according to size of data" do
    QRCode.new('1'*15, :level => :l).size.should == 1
    QRCode.new('1'*15, :level => :m).size.should == 2
    QRCode.new('1'*15, :level => :q).size.should == 2
    QRCode.new('1'*15, :level => :h).size.should == 3

    QRCode.new('1'*30, :level => :l).size.should == 2
    QRCode.new('1'*30, :level => :m).size.should == 3
    QRCode.new('1'*30, :level => :q).size.should == 3
    QRCode.new('1'*30, :level => :h).size.should == 4

    QRCode.new('1'*270, :level => :l).size.should == 10
  end

  it "should raise ArgumentError when data too large" do
    lambda{ QRCode.new('1'*271, :level => :l) }.should_not raise_error(ArgumentError)
    lambda{ QRCode.new('1'*272, :level => :l) }.should raise_error(ArgumentError)
  end


  def rqrcode(code)
    RQRCode::QRCode.new(code.data, :level => code.level, :size => code.size)
  end

end
