require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/outputter/prawn_outputter'
include Barby

describe PrawnOutputter do

  before :each do
    @barcode = Barcode.new
    def @barcode.encoding;  '10110011100011110000'; end
    @outputter = PrawnOutputter.new(@barcode)
  end

  it "should register to_pdf and annotate_pdf" do
    Barcode.outputters.should include(:to_pdf)
    Barcode.outputters.should include(:annotate_pdf)
  end

  it "should have a to_pdf method" do
    @outputter.should respond_to(:to_pdf)
  end

  it "should return a PDF document in a string on to_pdf" do
    @barcode.to_pdf.should be_an_instance_of(String)
  end

  it "should return the same Prawn::Document on annotate_pdf" do
    doc = Prawn::Document.new
    @barcode.annotate_pdf(doc).object_id.should == doc.object_id
  end

  it "should default x and y to margin value" do
    @outputter.margin = 123
    @outputter.x.should == 123
    @outputter.y.should == 123
  end

  it "should default ydim to xdim value" do
    @outputter.xdim = 321
    @outputter.ydim.should == 321
  end

  it "should be able to calculate width required" do
    @outputter.width.should == @barcode.encoding.length
    @outputter.xdim = 2
    @outputter.width.should == @barcode.encoding.length * 2
    @outputter.full_width.should == @barcode.encoding.length * 2
    @outputter.margin = 5
    @outputter.full_width.should == (@barcode.encoding.length * 2) + 10

    #2D
    barcode = Barcode2D.new
    def barcode.encoding; ['111', '000', '111'] end
    outputter = PrawnOutputter.new(barcode)
    outputter.width.should == 3
    outputter.xdim = 2
    outputter.margin = 5
    outputter.width.should == 6
    outputter.full_width.should == 16
  end

  it "should be able to calculate height required" do
    @outputter.full_height.should == @outputter.height
    @outputter.margin = 5
    @outputter.full_height.should == @outputter.height + 10

    #2D
    barcode = Barcode2D.new
    def barcode.encoding; ['111', '000', '111'] end
    outputter = PrawnOutputter.new(barcode)
    outputter.height.should == 3
    outputter.xdim = 2 #ydim defaults to xdim
    outputter.margin = 5
    outputter.height.should == 6
    outputter.full_height.should == 16
    outputter.ydim = 3 #ydim overrides xdim when set
    outputter.height.should == 9
    outputter.full_height.should == 19
  end

end
