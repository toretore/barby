require 'test_helper'
require 'barby/barcode/qr_code'

class QrCodeTest < Barby::TestCase

  before do
    @data = 'Ereshkigal'
    @code = QrCode.new(@data)
  end

  it "should have the expected data" do
    _(@code.data).must_equal @data
  end

  it "should have the expected encoding" do
    # Should be an array of strings, where each string represents a "line"
    _(@code.encoding).must_equal(rqrcode(@code).modules.map do |line|
      line.inject(''){|s,m| s << (m ? '1' : '0') }
    end)

  end
  
  it "should be able to change its data and output a different encoding" do
    @code.data = 'hades'
    _(@code.data).must_equal 'hades'
    _(@code.encoding).must_equal(rqrcode(@code).modules.map do |line|
      line.inject(''){|s,m| s << (m ? '1' : '0') }
    end)
  end
  
  it "should have a 'level' accessor" do
    _(@code).must_respond_to :level
    _(@code).must_respond_to :level=
  end
  
  it "should set size according to size of data" do
    _(QrCode.new('1'*15, :level => :l).size).must_equal 1
    _(QrCode.new('1'*15, :level => :m).size).must_equal 2
    _(QrCode.new('1'*15, :level => :q).size).must_equal 2
    _(QrCode.new('1'*15, :level => :h).size).must_equal 3
  
    _(QrCode.new('1'*30, :level => :l).size).must_equal 2
    _(QrCode.new('1'*30, :level => :m).size).must_equal 3
    _(QrCode.new('1'*30, :level => :q).size).must_equal 3
    _(QrCode.new('1'*30, :level => :h).size).must_equal 4
  
    _(QrCode.new('1'*270, :level => :l).size).must_equal 10
  end
  
  it "should allow size to be set manually" do
    code = QrCode.new('1'*15, :level => :l, :size => 2)
    _(code.size).must_equal 2
    _(code.encoding).must_equal(rqrcode(code).modules.map do |line|
      line.inject(''){|s,m| s << (m ? '1' : '0') }
    end)
  end
  
  it "should raise ArgumentError when data too large" do
    assert QrCode.new('1'*2953, :level => :l)
    _ { QrCode.new('1'*2954, :level => :l) }.must_raise ArgumentError
  end
  
  it "should return the original data on to_s" do
    _(@code.to_s).must_equal 'Ereshkigal'
  end
  
  it "should include at most 20 characters on to_s" do
    _(QrCode.new('123456789012345678901234567890').to_s).must_equal '12345678901234567890'
  end

  
  private
  
  def rqrcode(code)
    RQRCode::QRCode.new(code.data, :level => code.level, :size => code.size)
  end

end
