unless RUBY_VERSION >= '1.9'

  require 'test_helper'
  require 'pdf/writer'

  class PDFWriterOutputterTest < Barby::TestCase

    before do
      load_outputter('pdfwriter')
      @barcode = Barcode.new
      def @barcode.encoding; '101100111000'; end
      @outputter = PDFWriterOutputter.new(@barcode)
      @pdf = PDF::Writer.new
    end

    it "should have registered annotate_pdf" do
      _(Barcode.outputters).must_include(:annotate_pdf)
    end

    it "should have defined the annotate_pdf method" do
      _(@outputter).must_respond_to(:annotate_pdf)
    end

    it "should return the pdf object it was given in annotate_pdf" do
      _(@barcode.annotate_pdf(@pdf).object_id).must_equal @pdf.object_id
    end

    it "should have x, y, height and xdim attributes" do
      _(@outputter).must_respond_to(:x)
      _(@outputter).must_respond_to(:y)
      _(@outputter).must_respond_to(:height)
      _(@outputter).must_respond_to(:xdim)
    end

  end

end
