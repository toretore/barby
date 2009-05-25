require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/outputter/svg_outputter'
include Barby

class TestBarcode < Barcode
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


describe SvgOutputter do

  before :each do
    @barcode = TestBarcode.new('10110011100011110000')
    @outputter = SvgOutputter.new(@barcode)
  end

  it 'should register to_svg, bars_to_rects, and bars_to_path' do
    Barcode.outputters.should include(:to_svg, :bars_to_rects, :bars_to_path)
  end

  it 'should return a string on to_svg' do
    @barcode.to_svg.should be_an_instance_of(String)
  end
  
  it 'should return a string on bars_to_rects' do
    @barcode.bars_to_rects.should be_an_instance_of(String)
  end
  
  it 'should return a string on bars_to_path' do
    @barcode.bars_to_path.should be_an_instance_of(String)
  end

  it 'should produce one rect for each bar' do
    @barcode.bars_to_rects.scan(/<rect/).size.should == @outputter.send(:boolean_groups).select{|bg|bg[0]}.size
  end
  
  it 'should produce one path stroke for each bar module' do
    @barcode.bars_to_path.scan(/(M\d+\s+\d+)\s*(V\d+)/).size.should == @outputter.send(:booleans).select{|bg|bg}.size
  end

  it 'should return default values for attributes' do
    @outputter.margin.should be_an_instance_of(Fixnum)
  end
  
  it 'should use defaults to populate higher level attributes' do
    @outputter.xmargin.should == @outputter.margin
  end
  
  it 'should return nil for overridden attributes' do
    @outputter.xmargin = 1
    @outputter.margin.should == nil
  end
  
  it 'should still use defaults for unspecified attributes' do
    @outputter.xmargin = 1
    @outputter.ymargin.should == @outputter.send(:_margin)
  end
  
  it 'should have a width equal to Xdim * barcode_string.length' do
    @outputter.width.should == @outputter.barcode.encoding.length * @outputter.xdim
  end

  it 'should have a full_width which is by default the sum of width + (margin*2)' do
    @outputter.full_width.should == @outputter.width + (@outputter.margin*2)
  end
  
  it 'should have a full_width which is the sum of width + xmargin + ymargin' do
    @outputter.full_width.should == @outputter.width + @outputter.xmargin + @outputter.ymargin
  end
  
  it 'should use Barcode#to_s for title' do
    @outputter.title.should == @barcode.data
    def @barcode.to_s; "the eastern star"; end
    @outputter.title.should == "the eastern star"
  end

end
