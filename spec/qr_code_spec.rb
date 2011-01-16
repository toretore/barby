require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/barcode/qr_code'
begin#Only test RQREncoder if it's installed
  require 'rqrencoder'
rescue LoadError
end


describe Barby::RQRCode do

  before :each do
    @data = 'Ereshkigal'
    @code = Barby::RQRCode.new(@data)
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
    Barby::RQRCode.new('1'*15, :level => :l).size.should == 1
    Barby::RQRCode.new('1'*15, :level => :m).size.should == 2
    Barby::RQRCode.new('1'*15, :level => :q).size.should == 2
    Barby::RQRCode.new('1'*15, :level => :h).size.should == 3

    Barby::RQRCode.new('1'*30, :level => :l).size.should == 2
    Barby::RQRCode.new('1'*30, :level => :m).size.should == 3
    Barby::RQRCode.new('1'*30, :level => :q).size.should == 3
    Barby::RQRCode.new('1'*30, :level => :h).size.should == 4

    Barby::RQRCode.new('1'*270, :level => :l).size.should == 10
  end

  it "should allow size to be set manually" do
    code = Barby::RQRCode.new('1'*15, :level => :l, :size => 2)
    code.size.should == 2
    code.encoding.should == rqrcode(code).modules.map do |line|
      line.inject(''){|s,m| s << (m ? '1' : '0') }
    end
  end

  it "should raise ArgumentError when data too large" do
    lambda{ Barby::RQRCode.new('1'*2953, :level => :l) }.should_not raise_error(ArgumentError)
    lambda{ Barby::RQRCode.new('1'*2954, :level => :l) }.should raise_error(ArgumentError)
  end

  it "should return the original data on to_s" do
    @code.to_s.should == 'Ereshkigal'
  end

  it "should include at most 20 characters on to_s" do
    Barby::RQRCode.new('123456789012345678901234567890').to_s.should == '12345678901234567890'
  end


  def rqrcode(code)
    RQRCode::QRCode.new(code.data, :level => code.level, :size => code.size)
  end

end



if defined?(RQREncoder)

  describe Barby::RQREncoder do


    before :each do
      @data = 'Arjuna'
      @code = Barby::RQREncoder.new(@data)
    end

    it 'should have the expected encoding' do
      @code.encoding.should == qrcode(@code).modules.map{|line| line.map{|mod| mod ? '1' : '0' }.join }
    end

    it 'should be able to change its data' do
      prev_encoding = @code.encoding
      @code.data = 'Krishna'
      @code.encoding.should_not == prev_encoding
    end


    def qrcode(code)
      RQREncoder::QREncoder.new.encode(code.data)
    end

  end

end
