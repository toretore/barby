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
    assert Barcode.outputters.include?(:to_png)
    assert Barcode.outputters.include?(:to_image)
  end

  it "should return a ChunkyPNG::Datastream on to_datastream" do
    assert @barcode.to_datastream.is_a?(ChunkyPNG::Datastream)
  end

  it "should return a string on to_png" do
    assert @barcode.to_png.is_a?(String)
  end

  it "should return a ChunkyPNG::Image on to_canvas" do
    assert @barcode.to_image.is_a?(ChunkyPNG::Image)
  end

  it "should have a width equal to Xdim * barcode_string.length" do
    assert_equal @outputter.barcode.encoding.length * @outputter.xdim, @outputter.width
  end

  it "should have a full_width which is the sum of width + (margin*2)" do
    assert_equal(@outputter.width + (@outputter.margin*2), @outputter.full_width)
  end

  it "should have a full_height which is the sum of height + (margin*2)" do
    assert_equal(@outputter.height + (@outputter.margin*2), @outputter.full_height)
  end

end
