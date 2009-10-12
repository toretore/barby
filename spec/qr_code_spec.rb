require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/barcode/qr_code'
include Barby


describe QrCode do

  before :each do
    @data = 'Ereshkigal'
    @code = QrCode.new(@data)
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
    QrCode.new('1'*15, :level => :l).size.should == 1
    QrCode.new('1'*15, :level => :m).size.should == 2
    QrCode.new('1'*15, :level => :q).size.should == 2
    QrCode.new('1'*15, :level => :h).size.should == 3

    QrCode.new('1'*30, :level => :l).size.should == 2
    QrCode.new('1'*30, :level => :m).size.should == 3
    QrCode.new('1'*30, :level => :q).size.should == 3
    QrCode.new('1'*30, :level => :h).size.should == 4

    QrCode.new('1'*270, :level => :l).size.should == 10
  end

  it "should allow size to be set manually" do
    code = QrCode.new('1'*15, :level => :l, :size => 2)
    code.size.should == 2
    code.encoding.should == rqrcode(code).modules.map do |line|
      line.inject(''){|s,m| s << (m ? '1' : '0') }
    end
  end

  it "should raise ArgumentError when data too large" do
    lambda{ QrCode.new('1'*2953, :level => :l) }.should_not raise_error(ArgumentError)
    lambda{ QrCode.new('1'*2954, :level => :l) }.should raise_error(ArgumentError)
  end

  it "should return the original data on to_s" do
    @code.to_s.should == 'Ereshkigal'
  end

  it "should include at most 20 characters on to_s" do
    QrCode.new('123456789012345678901234567890').to_s.should == '12345678901234567890'
  end


  def rqrcode(code)
    RQRCode::QRCode.new(code.data, :level => code.level, :size => code.size)
  end

end
