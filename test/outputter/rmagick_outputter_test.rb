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
    assert Barcode.outputters.include?(:to_png)
    assert Barcode.outputters.include?(:to_gif)
    assert Barcode.outputters.include?(:to_jpg)
    assert Barcode.outputters.include?(:to_image)
  end

  it "should have defined to_png, to_gif, to_jpg, to_image" do
    assert @outputter.respond_to?(:to_png)
    assert @outputter.respond_to?(:to_gif)
    assert @outputter.respond_to?(:to_jpg)
    assert @outputter.respond_to?(:to_image)
  end

  it "should return a string on to_png and to_gif" do
    assert @outputter.to_png.is_a?(String)
    assert @outputter.to_gif.is_a?(String)
  end

  it "should return a Magick::Image instance on to_image" do
    assert @outputter.to_image.is_a?(Magick::Image)
  end

  it "should have a width equal to the length of the barcode encoding string * x dimension" do
    assert_equal 1, @outputter.xdim #Default
    assert_equal @outputter.barcode.encoding.length, @outputter.width
    @outputter.xdim = 2
    assert_equal @outputter.barcode.encoding.length * 2, @outputter.width
  end

  it "should have a full_width equal to the width + left and right margins" do
    assert_equal 1, @outputter.xdim
    assert_equal 10, @outputter.margin
    assert_equal((@outputter.width + 10 + 10), @outputter.full_width)
  end

  it "should have a default height of 100" do
    assert_equal 100, @outputter.height
    @outputter.height = 200
    assert_equal 200, @outputter.height
  end

  it "should have a full_height equal to the height + top and bottom margins" do
    assert_equal(@outputter.height + (@outputter.margin * 2), @outputter.full_height)
  end

  describe "#to_image" do

    before do
      @barcode = RmagickTestBarcode.new('10110011100011110000')
      @outputter = RmagickOutputter.new(@barcode)
      @image = @outputter.to_image
    end

    it "should have a width and height equal to the outputter's full_width and full_height" do
      assert_equal @outputter.full_width, @image.columns
      assert_equal @outputter.full_height, @image.rows
    end

  end

end


