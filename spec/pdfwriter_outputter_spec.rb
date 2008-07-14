require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/outputter/pdfwriter_outputter'
require 'pdf/writer'
include Barby

describe PDFWriterOutputter do

  before :each do
    @barcode = Barcode.new
    def @barcode.encoding; '101100111000'; end
    @outputter = PDFWriterOutputter.new(@barcode)
    @pdf = PDF::Writer.new
  end

  it "should have registered annotate_pdf" do
    Barcode.outputters.should include(:annotate_pdf)
  end

  it "should have defined the annotate_pdf method" do
    @outputter.should respond_to(:annotate_pdf)
  end

  it "should return the pdf object it was given in annotate_pdf" do
    @barcode.annotate_pdf(@pdf).object_id.should == @pdf.object_id
  end

  it "should have x, y, height and xdim attributes" do
    @outputter.should respond_to(:x)
    @outputter.should respond_to(:y)
    @outputter.should respond_to(:height)
    @outputter.should respond_to(:xdim)
  end

end
