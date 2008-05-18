require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/outputter'
require 'barby/outputter/cairo_outputter'

describe Barby::CairoOutputter do
  def ps_available?
    Cairo.const_defined?(:PSSurface)
  end

  def eps_available?
    ps_available? and Cairo::PSSurface.respond_to?(:eps=)
  end

  def pdf_available?
    Cairo.const_defined?(:PDFSurface)
  end

  def svg_available?
    Cairo.const_defined?(:SVGSurface)
  end

  before :each do
    @barcode = Barby::Barcode.new
    def @barcode.encoding; '101100111000'; end
    @outputter = Barby::CairoOutputter.new(@barcode)
    @outputters = Barby::Barcode.outputters
    @surface = Cairo::ImageSurface.new(100, 100)
    @context = Cairo::Context.new(@surface)
  end

  it "should have defined the render_to_cairo_context method" do
    @outputters.should include(:render_to_cairo_context)
  end

  it "should have defined the to_png method" do
    @outputters.should include(:to_png)
  end

  it "should have defined the to_ps and to_eps method if available" do
    if ps_available?
      @outputters.should include(:to_ps)
      if eps_available?
        @outputters.should include(:to_eps)
      else
        @outputters.should_not include(:to_eps)
      end
    else
      @outputters.should_not include(:to_ps)
      @outputters.should_not include(:to_eps)
    end
  end

  it "should have defined the to_pdf method if available" do
    if pdf_available?
      @outputters.should include(:to_pdf)
    else
      @outputters.should_not include(:to_pdf)
    end
  end

  it "should have defined the to_svg method if available" do
    if svg_available?
      @outputters.should include(:to_svg)
    else
      @outputters.should_not include(:to_svg)
    end
  end

  it "should return the cairo context object it was given in render_to_cairo_context" do
    @barcode.render_to_cairo_context(@context).object_id.should == @context.object_id
  end

  it "should return PNG image by the to_png method" do
    @barcode.to_png.should match(/\A\x89PNG/)
  end

  it "should return PS document by the to_ps method" do
    if ps_available?
      @barcode.to_ps.should match(/\A%!PS-Adobe-[\d.]/)
    end
  end

  it "should return EPS document by the to_eps method" do
    if eps_available?
      @barcode.to_eps.should match(/\A%!PS-Adobe-[\d.]+ EPSF-[\d.]+/)
    end
  end

  it "should return PDF document by the to_pdf method" do
    if pdf_available?
      @barcode.to_pdf.should match(/\A%PDF-[\d.]+/)
    end
  end

  it "should return SVG document by the to_svg method" do
    if svg_available?
      @barcode.to_svg.should match(/<\/svg>\s*\Z/m)
    end
  end

  it "should have x, y, width, height, full_width, full_height, xdim and margin attributes" do
    @outputter.should respond_to(:x)
    @outputter.should respond_to(:y)
    @outputter.should respond_to(:width)
    @outputter.should respond_to(:height)
    @outputter.should respond_to(:full_width)
    @outputter.should respond_to(:full_height)
    @outputter.should respond_to(:xdim)
    @outputter.should respond_to(:margin)
  end

  it "should not change attributes when given an options hash to render" do
    %w(x y height xdim).each do |m|
      @outputter.send("#{m}=", 10)
      @outputter.send(m).should == 10
    end
    @outputter.render_to_cairo_context(@context,
                                       :x => 20,
                                       :y => 20,
                                       :height => 20,
                                       :xdim => 20)
    %w(x y height xdim).each{|m| @outputter.send(m).should == 10 }
  end
end
