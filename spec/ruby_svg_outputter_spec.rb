require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/outputter/ruby_svg_outputter'
include Barby

class TestBarcode < Barcode
  def initialize(data, two_d=false)
    @data = data
    @two_d = two_d
  end
  def encoding
    @data
  end
  def two_dimensional?
    @two_d
  end
end


describe RubySvgOutputter do

  before :each do
    @barcode = TestBarcode.new('10110011100011110000')
    @outputter = RubySvgOutputter.new(@barcode)
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

  it 'should not complain if there is no valid title' do
    @outputter.title.should == nil
  end
  
  it 'should use data for title if possible' do
    class TestBarcode
      def data; @data; end
    end
    @outputter.title.should == @barcode.data
  end
  
  it 'should prefer full_data for title if full_data is defined' do
    class TestBarcode
      def data; :data; end
      def full_data; :full_data; end
    end
    @outputter.title.should == :full_data
  end

end
