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
      assert Barcode.outputters.include?(:annotate_pdf)
    end

    it "should have defined the annotate_pdf method" do
      assert @outputter.respond_to?(:annotate_pdf)
    end

    it "should return the pdf object it was given in annotate_pdf" do
      assert_equal @pdf.object_id, @barcode.annotate_pdf(@pdf).object_id
    end

    it "should have x, y, height and xdim attributes" do
      assert @outputter.respond_to?(:x)
      assert @outputter.respond_to?(:y)
      assert @outputter.respond_to?(:height)
      assert @outputter.respond_to?(:xdim)
    end

  end

end
