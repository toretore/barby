require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/outputter/rmagick_outputter'
include Barby

class TestBarcode < Barcode
  def initialize(data)
    @data = data
  end
  def encoding
    @data
  end
end

describe RmagickOutputter do

  before :each do
    @barcode = TestBarcode.new('10110011100011110000')
    @outputter = RmagickOutputter.new(@barcode)
  end

  it "should register to_png, to_gif, to_jpg, to_image" do
    Barcode.outputters.should include(:to_png, :to_gif, :to_jpg, :to_image)
  end

  it "should have defined to_png, to_gif, to_jpg, to_image" do
    @outputter.should respond_to(:to_png, :to_gif, :to_jpg, :to_image)
  end

  it "should return a string on to_png and to_gif" do
    @outputter.to_png.should be_an_instance_of(String)
    @outputter.to_gif.should be_an_instance_of(String)
  end

  it "should return a Magick::Image instance on to_image" do
    @outputter.to_image.should be_an_instance_of(Magick::Image)
  end

  it "should have a width equal to the length of the barcode encoding string * x dimension" do
    @outputter.xdim.should == 1#Default
    @outputter.width.should == @outputter.barcode.encoding.length
    @outputter.xdim = 2
    @outputter.width.should == @outputter.barcode.encoding.length * 2
  end

  it "should have a full_width equal to the width + left and right margins" do
    @outputter.xdim.should == 1
    @outputter.margin.should == 10
    @outputter.full_width.should == (@outputter.width + 10 + 10)
  end

  it "should have a default height of 100" do
    @outputter.height.should == 100
    @outputter.height = 200
    @outputter.height.should == 200
  end

  it "should have a full_height equal to the height + top and bottom margins" do
    @outputter.full_height.should == @outputter.height + (@outputter.margin * 2)
  end

end

describe "Rmagickoutputter#to_image" do

  before :each do 
    @barcode = TestBarcode.new('10110011100011110000')
    @outputter = RmagickOutputter.new(@barcode)
    @image = @outputter.to_image
  end

  it "should have a width and height equal to the outputter's full_width and full_height" do
    @image.columns.should == @outputter.full_width
    @image.rows.should == @outputter.full_height
  end

end
