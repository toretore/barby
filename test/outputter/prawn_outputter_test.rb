require 'test_helper'

class PrawnOutputterTest < Barby::TestCase

  before do
    load_outputter('prawn')
    @barcode = Barcode.new
    def @barcode.encoding;  '10110011100011110000'; end
    @outputter = PrawnOutputter.new(@barcode)
  end

  it "should register to_pdf and annotate_pdf" do
    assert Barcode.outputters.include?(:to_pdf)
    assert Barcode.outputters.include?(:annotate_pdf)
  end

  it "should have a to_pdf method" do
    assert @outputter.respond_to?(:to_pdf)
  end

  it "should return a PDF document in a string on to_pdf" do
    assert @barcode.to_pdf.is_a?(String)
  end

  it "should return the same Prawn::Document on annotate_pdf" do
    doc = Prawn::Document.new
    assert_equal doc.object_id, @barcode.annotate_pdf(doc).object_id
  end

  it "should default x and y to margin value" do
    @outputter.margin = 123
    assert_equal 123, @outputter.x
    assert_equal 123, @outputter.y
  end

  it "should default ydim to xdim value" do
    @outputter.xdim = 321
    assert_equal 321, @outputter.ydim
  end

  it "should be able to calculate width required" do
    assert_equal @barcode.encoding.length, @outputter.width
    @outputter.xdim = 2
    assert_equal @barcode.encoding.length * 2, @outputter.width
    assert_equal @barcode.encoding.length * 2, @outputter.full_width
    @outputter.margin = 5
    assert_equal((@barcode.encoding.length * 2) + 10, @outputter.full_width)

    #2D
    barcode = Barcode2D.new
    def barcode.encoding; ['111', '000', '111'] end
    outputter = PrawnOutputter.new(barcode)
    assert_equal 3, outputter.width
    outputter.xdim = 2
    outputter.margin = 5
    assert_equal 6, outputter.width
    assert_equal 16, outputter.full_width
  end

  it "should be able to calculate height required" do
    assert_equal @outputter.height, @outputter.full_height
    @outputter.margin = 5
    assert_equal @outputter.height + 10, @outputter.full_height

    #2D
    barcode = Barcode2D.new
    def barcode.encoding; ['111', '000', '111'] end
    outputter = PrawnOutputter.new(barcode)
    assert_equal 3, outputter.height
    outputter.xdim = 2 #ydim defaults to xdim
    outputter.margin = 5
    assert_equal 6, outputter.height
    assert_equal 16, outputter.full_height
    outputter.ydim = 3 #ydim overrides xdim when set
    assert_equal 9, outputter.height
    assert_equal 19, outputter.full_height
  end

end
