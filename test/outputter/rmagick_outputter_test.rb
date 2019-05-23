require 'test_helper'

class RmagickTestBarcode < Barby::Barcode
  def initialize(data)
    @data = data
  end
  def encoding
    @data
  end
end

class RmagickOutputterTest < Barby::TestCase

  before do
    load_outputter('rmagick')
    @barcode = RmagickTestBarcode.new('10110011100011110000')
    @outputter = RmagickOutputter.new(@barcode)
  end

  it "should register to_png, to_gif, to_jpg, to_image" do
    Barcode.outputters.must_include(:to_png)
    Barcode.outputters.must_include(:to_gif)
    Barcode.outputters.must_include(:to_jpg)
    Barcode.outputters.must_include(:to_image)
  end

  it "should have defined to_png, to_gif, to_jpg, to_image" do
    @outputter.must_respond_to(:to_png)
    @outputter.must_respond_to(:to_gif)
    @outputter.must_respond_to(:to_jpg)
    @outputter.must_respond_to(:to_image)
  end

  it "should return a string on to_png and to_gif" do
    @outputter.to_png.must_be_instance_of(String)
    @outputter.to_gif.must_be_instance_of(String)
  end

  it "should return a Magick::Image instance on to_image" do
    @outputter.to_image.must_be_instance_of(Magick::Image)
  end

  it "should have a width equal to the length of the barcode encoding string * x dimension" do
    @outputter.xdim.must_equal 1#Default
    @outputter.width.must_equal @outputter.barcode.encoding.length
    @outputter.xdim = 2
    @outputter.width.must_equal @outputter.barcode.encoding.length * 2
  end

  it "should have a full_width equal to the width + left and right margins" do
    @outputter.xdim.must_equal 1
    @outputter.margin.must_equal 10
    @outputter.full_width.must_equal (@outputter.width + 10 + 10)
  end

  it "should have a default height of 100" do
    @outputter.height.must_equal 100
    @outputter.height = 200
    @outputter.height.must_equal 200
  end

  it "should have a full_height equal to the height + top and bottom margins" do
    @outputter.full_height.must_equal @outputter.height + (@outputter.margin * 2)
  end

  describe "#to_image" do

    before do
      @barcode = RmagickTestBarcode.new('10110011100011110000')
      @outputter = RmagickOutputter.new(@barcode)
      @image = @outputter.to_image
    end

    it "should have a width and height equal to the outputter's full_width and full_height" do
      @image.columns.must_equal @outputter.full_width
      @image.rows.must_equal @outputter.full_height
    end

  end

end


