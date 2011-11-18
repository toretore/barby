require 'test_helper'

class PngTestBarcode < Barby::Barcode
  def initialize(data)
    @data = data
  end
  def encoding
    @data
  end
end

class PngOutputterTest < Barby::TestCase

  before do
    load_outputter('png')
    @barcode = PngTestBarcode.new('10110011100011110000')
    @outputter = PngOutputter.new(@barcode)
  end
  
  it "should register to_png and to_image" do
    Barcode.outputters.must_include(:to_png)
    Barcode.outputters.must_include(:to_image)
  end

  it "should return a ChunkyPNG::Datastream on to_datastream" do
    @barcode.to_datastream.must_be_instance_of(ChunkyPNG::Datastream)
  end

  it "should return a string on to_png" do
    @barcode.to_png.must_be_instance_of(String)
  end

  it "should return a ChunkyPNG::Image on to_canvas" do
    @barcode.to_image.must_be_instance_of(ChunkyPNG::Image)
  end

  it "should have a width equal to Xdim * barcode_string.length" do
    @outputter.width.must_equal @outputter.barcode.encoding.length * @outputter.xdim
  end

  it "should have a full_width which is the sum of width + (margin*2)" do
    @outputter.full_width.must_equal @outputter.width + (@outputter.margin*2)
  end

  it "should have a full_height which is the sum of height + (margin*2)" do
    @outputter.full_height.must_equal @outputter.height + (@outputter.margin*2)
  end

end
