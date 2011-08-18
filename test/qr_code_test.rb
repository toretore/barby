require 'test_helper'
require 'barby/barcode/qr_code'

class QrCodeTest < Barby::TestCase

  before do
    @data = 'Ereshkigal'
    @code = QrCode.new(@data)
  end

  it "should have the expected data" do
    @code.data.must_equal @data
  end

  it "should have the expected encoding" do
    # Should be an array of strings, where each string represents a "line"
    @code.encoding.must_equal(rqrcode(@code).modules.map do |line|
      line.inject(''){|s,m| s << (m ? '1' : '0') }
    end)

  end
  
  it "should be able to change its data and output a different encoding" do
    @code.data = 'hades'
    @code.data.must_equal 'hades'
    @code.encoding.must_equal(rqrcode(@code).modules.map do |line|
      line.inject(''){|s,m| s << (m ? '1' : '0') }
    end)
  end
  
  it "should have a 'level' accessor" do
    @code.must_respond_to :level
    @code.must_respond_to :level=
  end
  
  it "should set size according to size of data" do
    QrCode.new('1'*15, :level => :l).size.must_equal 1
    QrCode.new('1'*15, :level => :m).size.must_equal 2
    QrCode.new('1'*15, :level => :q).size.must_equal 2
    QrCode.new('1'*15, :level => :h).size.must_equal 3
  
    QrCode.new('1'*30, :level => :l).size.must_equal 2
    QrCode.new('1'*30, :level => :m).size.must_equal 3
    QrCode.new('1'*30, :level => :q).size.must_equal 3
    QrCode.new('1'*30, :level => :h).size.must_equal 4
  
    QrCode.new('1'*270, :level => :l).size.must_equal 10
  end
  
  it "should allow size to be set manually" do
    code = QrCode.new('1'*15, :level => :l, :size => 2)
    code.size.must_equal 2
    code.encoding.must_equal(rqrcode(code).modules.map do |line|
      line.inject(''){|s,m| s << (m ? '1' : '0') }
    end)
  end
  
  it "should raise ArgumentError when data too large" do
    assert QrCode.new('1'*2953, :level => :l)
    lambda{ QrCode.new('1'*2954, :level => :l) }.must_raise ArgumentError
  end
  
  it "should return the original data on to_s" do
    @code.to_s.must_equal 'Ereshkigal'
  end
  
  it "should include at most 20 characters on to_s" do
    QrCode.new('123456789012345678901234567890').to_s.must_equal '12345678901234567890'
  end

  
  private
  
  def rqrcode(code)
    RQRCode::QRCode.new(code.data, :level => code.level, :size => code.size)
  end

end
