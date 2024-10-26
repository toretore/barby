require 'test_helper'
require 'barby/barcode/qr_code'

class QrCodeTest < Barby::TestCase

  before do
    @data = 'Ereshkigal'
    @code = QrCode.new(@data)
  end

  it "should have the expected data" do
    assert_equal @data, @code.data
  end

  it "should have the expected encoding" do
    # Should be an array of strings, where each string represents a "line"
    expected = rqrcode(@code).modules.map do |line|
      line.inject(''){|s,m| s << (m ? '1' : '0') }
    end
    assert_equal expected, @code.encoding

  end

  it "should be able to change its data and output a different encoding" do
    @code.data = 'hades'
    assert_equal 'hades', @code.data
    expected = rqrcode(@code).modules.map do |line|
      line.inject(''){|s,m| s << (m ? '1' : '0') }
    end
    assert_equal expected, @code.encoding
  end

  it "should have a 'level' accessor" do
    assert @code.respond_to?(:level)
    assert @code.respond_to?(:level=)
  end

  it "should set size according to size of data" do
    assert_equal 1, QrCode.new('1'*15, level: :l).size
    assert_equal 2, QrCode.new('1'*15, level: :m).size
    assert_equal 2, QrCode.new('1'*15, level: :q).size
    assert_equal 3, QrCode.new('1'*15, level: :h).size

    assert_equal 2, QrCode.new('1'*30, level: :l).size
    assert_equal 3, QrCode.new('1'*30, level: :m).size
    assert_equal 3, QrCode.new('1'*30, level: :q).size
    assert_equal 4, QrCode.new('1'*30, level: :h).size

    assert_equal 10, QrCode.new('1'*270, level: :l).size
  end

  it "should allow size to be set manually" do
    code = QrCode.new('1'*15, level: :l, size: 2)
    assert_equal 2, code.size
    expected = rqrcode(code).modules.map do |line|
      line.inject(''){|s,m| s << (m ? '1' : '0') }
    end
    assert_equal expected, code.encoding
  end

  it "should raise ArgumentError when data too large" do
    QrCode.new('1'*2953, level: :l)
    assert_raises ArgumentError do
      QrCode.new('1'*2954, level: :l)
    end
  end

  it "should return the original data on to_s" do
    assert_equal 'Ereshkigal', @code.to_s
  end

  it "should include at most 20 characters on to_s" do
    assert_equal '12345678901234567890', QrCode.new('123456789012345678901234567890').to_s
  end


  private

  def rqrcode(code)
    RQRCode::QRCode.new(code.data, level: code.level, size: code.size)
  end

end
