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

end
