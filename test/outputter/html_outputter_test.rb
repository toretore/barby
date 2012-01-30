require 'test_helper'

class HtmlOutputterTest < Barby::TestCase

  before do
    load_outputter('html')
    @barcode = Barby::Code128B.new('BARBY')
    @outputter = HtmlOutputter.new(@barcode)
  end
  
  it "should register to_html" do
    Barcode.outputters.must_include(:to_html)
  end
  
  it "should include css style tag by default with option to leave out" do
    @barcode.to_html.must_include "<style>#{Barby::HtmlOutputter.css}</style>"
    @barcode.to_html(:css => false).wont_include "<style>#{Barby::HtmlOutputter.css}</style>"
  end
  
  it "should include inline parent style for width and height with option to disable" do
    @barcode.to_html.must_include '<table class="barby_code" style="width: 100px; height: 100px;">'
    @barcode.to_html(:parent_style => false).must_include '<table class="barby_code" >'
  end

  it "should include valid black and white tags"
    @barcode.to_html.must_include '<td class="barby_black"></td>'
    @barcode.to_html.must_include '<td class="barby_white"></td>'
  end

  it "should not output the rows as an array"
    @barcode.to_html.wont_include '['
    @barcode.to_html.wont_include ']'
  end

end
