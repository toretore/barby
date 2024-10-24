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
    _(Barcode.outputters).must_include(:to_png)
    _(Barcode.outputters).must_include(:to_gif)
    _(Barcode.outputters).must_include(:to_jpg)
    _(Barcode.outputters).must_include(:to_image)
  end

  it "should have defined to_png, to_gif, to_jpg, to_image" do
    _(@outputter).must_respond_to(:to_png)
    _(@outputter).must_respond_to(:to_gif)
    _(@outputter).must_respond_to(:to_jpg)
    _(@outputter).must_respond_to(:to_image)
  end

  it "should return a string on to_png and to_gif" do
    _(@outputter.to_png).must_be_instance_of(String)
    _(@outputter.to_gif).must_be_instance_of(String)
  end

  it "should return a Magick::Image instance on to_image" do
    _(@outputter.to_image).must_be_instance_of(Magick::Image)
  end

  it "should have a width equal to the length of the barcode encoding string * x dimension" do
    _(@outputter.xdim).must_equal 1#Default
    _(@outputter.width).must_equal @outputter.barcode.encoding.length
    @outputter.xdim = 2
    _(@outputter.width).must_equal @outputter.barcode.encoding.length * 2
  end

  it "should have a full_width equal to the width + left and right margins" do
    _(@outputter.xdim).must_equal 1
    _(@outputter.margin).must_equal 10
    _(@outputter.full_width).must_equal (@outputter.width + 10 + 10)
  end

  it "should have a default height of 100" do
    _(@outputter.height).must_equal 100
    @outputter.height = 200
    _(@outputter.height).must_equal 200
  end

  it "should have a full_height equal to the height + top and bottom margins" do
    _(@outputter.full_height).must_equal @outputter.height + (@outputter.margin * 2)
  end

  describe "#to_image" do

    before do
      @barcode = RmagickTestBarcode.new('10110011100011110000')
      @outputter = RmagickOutputter.new(@barcode)
      @image = @outputter.to_image
    end

    it "should have a width and height equal to the outputter's full_width and full_height" do
      _(@image.columns).must_equal @outputter.full_width
      _(@image.rows).must_equal @outputter.full_height
    end

  end

end


