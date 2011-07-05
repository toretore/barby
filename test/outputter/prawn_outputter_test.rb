require 'test_helper'

class PrawnOutputterTest < Barby::TestCase

  before do
    load_outputter('prawn')
    @barcode = Barcode.new
    def @barcode.encoding;  '10110011100011110000'; end
    @outputter = PrawnOutputter.new(@barcode)
  end

  it "should register to_pdf and annotate_pdf" do
    Barcode.outputters.must_include(:to_pdf)
    Barcode.outputters.must_include(:annotate_pdf)
  end

  it "should have a to_pdf method" do
    @outputter.must_respond_to(:to_pdf)
  end

  it "should return a PDF document in a string on to_pdf" do
    @barcode.to_pdf.must_be_instance_of(String)
  end

  it "should return the same Prawn::Document on annotate_pdf" do
    doc = Prawn::Document.new
    @barcode.annotate_pdf(doc).object_id.must_equal doc.object_id
  end

  it "should default x and y to margin value" do
    @outputter.margin = 123
    @outputter.x.must_equal 123
    @outputter.y.must_equal 123
  end

  it "should default ydim to xdim value" do
    @outputter.xdim = 321
    @outputter.ydim.must_equal 321
  end

  it "should be able to calculate width required" do
    @outputter.width.must_equal @barcode.encoding.length
    @outputter.xdim = 2
    @outputter.width.must_equal @barcode.encoding.length * 2
    @outputter.full_width.must_equal @barcode.encoding.length * 2
    @outputter.margin = 5
    @outputter.full_width.must_equal((@barcode.encoding.length * 2) + 10)

    #2D
    barcode = Barcode2D.new
    def barcode.encoding; ['111', '000', '111'] end
    outputter = PrawnOutputter.new(barcode)
    outputter.width.must_equal 3
    outputter.xdim = 2
    outputter.margin = 5
    outputter.width.must_equal 6
    outputter.full_width.must_equal 16
  end

  it "should be able to calculate height required" do
    @outputter.full_height.must_equal @outputter.height
    @outputter.margin = 5
    @outputter.full_height.must_equal @outputter.height + 10

    #2D
    barcode = Barcode2D.new
    def barcode.encoding; ['111', '000', '111'] end
    outputter = PrawnOutputter.new(barcode)
    outputter.height.must_equal 3
    outputter.xdim = 2 #ydim defaults to xdim
    outputter.margin = 5
    outputter.height.must_equal 6
    outputter.full_height.must_equal 16
    outputter.ydim = 3 #ydim overrides xdim when set
    outputter.height.must_equal 9
    outputter.full_height.must_equal 19
  end

end
