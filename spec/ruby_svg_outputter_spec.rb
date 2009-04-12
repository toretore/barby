require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/outputter/ruby_svg_outputter'
include Barby

class Test1DBarcode < Barcode
  def initialize(data)
    @data = data
  end
  def encoding
    @data
  end
end


describe RubySvgOutputter do

  before :each do
    @barcode = Test1DBarcode.new('10110011100011110000')
    @outputter = RubySvgOutputter.new(@barcode)
  end

  it 'should register to_svg, bars_to_rects, and bars_to_path' do
    Barcode.outputters.should include(:to_svg, :bars_to_rects, :bars_to_path)
  end

  it "should return a string on to_svg" do
    @barcode.to_svg.should be_an_instance_of(String)
  end
  
  it 'should return a string on bars_to_rects' do
    @barcode.bars_to_rects.should be_an_instance_of(String)
  end
  
  it 'should return a string on bars_to_path' do
    @barcode.bars_to_path.should be_an_instance_of(String)
  end

  #it "should have a width equal to Xdim * barcode_string.length" do
    #@outputter.width.should == @outputter.barcode.encoding.length * @outputter.xdim
  #end

  #it "should have a full_width which is the sum of width + (margin*2)" do
    #@outputter.full_width.should == @outputter.width + (@outputter.margin*2)
  #end

  #it "should have a full_height which is the sum of height + (margin*2)" do
    #@outputter.full_height.should == @outputter.height + (@outputter.margin*2)
  #end

end
