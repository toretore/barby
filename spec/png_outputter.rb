require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/outputter/png_outputter'
include Barby

class TestBarcode < Barcode
  def initialize(data)
    @data = data
  end
  def encoding
    @data
  end
end


describe PngOutputter do

  before :each do
    @barcode = TestBarcode.new('10110011100011110000')
    @outputter = PngOutputter.new(@barcode)
  end

  it "should register to_png and to_image" do
    Barcode.outputters.should include(:to_png, :to_image)
  end

  it "should return a ChunkyPNG::Datastream on to_datastream" do
    @barcode.to_datastream.should be_an_instance_of(ChunkyPNG::Datastream)
  end

  it "should return a string on to_png" do
    @barcode.to_png.should be_an_instance_of(String)
  end

  it "should return a ChunkyPNG::Image on to_canvas" do
    @barcode.to_image.should be_an_instance_of(ChunkyPNG::Image)
  end

  it "should have a width equal to Xdim * barcode_string.length" do
    @outputter.width.should == @outputter.barcode.encoding.length * @outputter.xdim
  end

  it "should have a full_width which is the sum of width + (margin*2)" do
    @outputter.full_width.should == @outputter.width + (@outputter.margin*2)
  end

  it "should have a full_height which is the sum of height + (margin*2)" do
    @outputter.full_height.should == @outputter.height + (@outputter.margin*2)
  end

end
