require 'barby/outputter'
require 'cairo'
require 'stringio'

module Barby

  #Uses Cairo to render a barcode to a number of formats: PNG, PS, EPS, PDF and SVG
  #
  #Registers methods render_to_cairo_context, to_png, to_ps, to_eps, to_pdf and to_svg
  class CairoOutputter < Outputter

    register :render_to_cairo_context
    register :to_png

    if Cairo.const_defined?(:PSSurface)
      register :to_ps
      register :to_eps if Cairo::PSSurface.method_defined?(:eps=)
    end

    register :to_pdf if Cairo.const_defined?(:PDFSurface)
    register :to_svg if Cairo.const_defined?(:SVGSurface)

    attr_writer :x, :y, :xdim, :height, :margin


    #Render the barcode onto a Cairo context
    def render_to_cairo_context(context, options={})
      if context.respond_to?(:have_current_point?) and
          context.have_current_point?
        current_x, current_y = context.current_point
      else
        current_x = x(options) || margin(options)
        current_y = y(options) || margin(options)
      end

      _xdim = xdim(options)
      _height = height(options)
      original_current_x = current_x
      context.save do
        context.set_source_color(:black)
        context.fill do
          if barcode.two_dimensional?
            boolean_groups.each do |groups|
              groups.each do |bar,amount|
                current_width = _xdim * amount
                if bar
                  context.rectangle(current_x, current_y, current_width, _xdim)
                end
                current_x += current_width
              end
              current_x = original_current_x
              current_y += _xdim
            end
          else
            boolean_groups.each do |bar,amount|
              current_width = _xdim * amount
              if bar
                context.rectangle(current_x, current_y, current_width, _height)
              end
              current_x += current_width
            end
          end
        end
      end

      context
    end


    #Render the barcode to a PNG image
    def to_png(options={})
      output_to_string_io do |io|
        Cairo::ImageSurface.new(options[:format],
                                full_width(options),
                                full_height(options)) do |surface|
          render(surface, options)
          surface.write_to_png(io)
        end
      end
    end


    #Render the barcode to a PS document
    def to_ps(options={})
      output_to_string_io do |io|
        Cairo::PSSurface.new(io,
                             full_width(options),
                             full_height(options)) do |surface|
          surface.eps = options[:eps] if surface.respond_to?(:eps=)
          render(surface, options)
        end
      end
    end


    #Render the barcode to an EPS document
    def to_eps(options={})
      to_ps(options.merge(:eps => true))
    end


    #Render the barcode to a PDF document
    def to_pdf(options={})
      output_to_string_io do |io|
        Cairo::PDFSurface.new(io,
                              full_width(options),
                              full_height(options)) do |surface|
          render(surface, options)
        end
      end
    end


    #Render the barcode to an SVG document
    def to_svg(options={})
      output_to_string_io do |io|
        Cairo::SVGSurface.new(io,
                              full_width(options),
                              full_height(options)) do |surface|
          render(surface, options)
        end
      end
    end


    def x(options={})
      @x || options[:x]
    end

    def y(options={})
      @y || options[:y]
    end

    def width(options={})
      (barcode.two_dimensional? ? encoding.first.length : encoding.length) * xdim(options)
    end

    def height(options={})
      if barcode.two_dimensional?
        encoding.size * xdim(options)
      else
        @height || options[:height] || 50
      end
    end

    def full_width(options={})
      width(options) + (margin(options) * 2)
    end

    def full_height(options={})
      height(options) + (margin(options) * 2)
    end

    def xdim(options={})
      @xdim || options[:xdim] || 1
    end

    def margin(options={})
      @margin || options[:margin] || 10
    end


  private

    def output_to_string_io
      io = StringIO.new
      yield(io)
      io.rewind
      io.read
    end


    def render(surface, options)
      context = Cairo::Context.new(surface)
      yield(context) if block_given?
      context.set_source_color(options[:background] || :white)
      context.paint
      render_to_cairo_context(context, options)
      context
    end


  end

end
