require 'test_helper'

class SvgBarcode < Barby::Barcode
  attr_accessor :data, :two_d
  def initialize(data, two_d=false)
    self.data, self.two_d = data, two_d
  end
  def encoding
    data
  end
  def two_dimensional?
    two_d
  end
  def to_s
    data
  end
end


class SvgOutputterTest < Barby::TestCase

  before do
    load_outputter('svg')
    @barcode = SvgBarcode.new('10110011100011110000')
    @outputter = SvgOutputter.new(@barcode)
  end

  it 'should register to_svg, bars_to_rects, and bars_to_path' do
    assert Barcode.outputters.include?(:to_svg)
    assert Barcode.outputters.include?(:bars_to_rects)
    assert Barcode.outputters.include?(:bars_to_path)
  end

  it 'should return a string on to_svg' do
    assert @barcode.to_svg.is_a?(String)
  end

  it 'should return a string on bars_to_rects' do
    assert @barcode.bars_to_rects.is_a?(String)
  end

  it 'should return a string on bars_to_path' do
    assert @barcode.bars_to_path.is_a?(String)
  end

  it 'should produce one rect for each bar' do
    assert_equal @outputter.send(:boolean_groups).select{|bg|bg[0]}.size, @barcode.bars_to_rects.scan(/<rect/).size
  end

  it 'should produce one path stroke for each bar module' do
    assert_equal @outputter.send(:booleans).select{|bg|bg}.size, @barcode.bars_to_path.scan(/(M\d+\s+\d+)\s*(V\d+)/).size
  end

  it 'should return default values for attributes' do
    assert @outputter.margin.is_a?(Integer)
  end

  it 'should use defaults to populate higher level attributes' do
    assert_equal @outputter.margin, @outputter.xmargin
  end

  it 'should return nil for overridden attributes' do
    @outputter.xmargin = 1
    assert_equal nil, @outputter.margin
  end

  it 'should still use defaults for unspecified attributes' do
    @outputter.xmargin = 1
    assert_equal @outputter.send(:_margin), @outputter.ymargin
  end

  it 'should have a width equal to Xdim * barcode_string.length' do
    assert_equal @outputter.barcode.encoding.length * @outputter.xdim, @outputter.width
  end

  it 'should have a full_width which is by default the sum of width + (margin*2)' do
    assert_equal(@outputter.width + (@outputter.margin*2), @outputter.full_width)
  end

  it 'should have a full_width which is the sum of width + xmargin + ymargin' do
    assert_equal @outputter.width + @outputter.xmargin + @outputter.ymargin, @outputter.full_width
  end

  it 'should use Barcode#to_s for title' do
    assert_equal @barcode.data, @outputter.title
    def @barcode.to_s; "the eastern star"; end
    assert_equal "the eastern star", @outputter.title
  end

end
