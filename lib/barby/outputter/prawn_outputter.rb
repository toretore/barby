require 'barby/outputter'
require 'prawn'

module Barby

  class PrawnOutputter < Outputter

    register :to_pdf, :annotate_pdf

    attr_accessor :xdim, :ydim, :x, :y, :height, :margin


    def to_pdf(opts={})
      doc_opts = opts.delete(:document) || {}
      doc_opts[:page_size] ||= 'A4'
      annotate_pdf(Prawn::Document.new(doc_opts), opts).render
    end


    def annotate_pdf(pdf, opts={})
      with_options opts do
        xpos, ypos = x, y
        orig_xpos = xpos

        if barcode.two_dimensional?
          boolean_groups.reverse_each do |groups|
            groups.each do |bar,amount|
              if bar
                pdf.move_to(xpos, ypos)
                pdf.line_to(xpos, ypos+ydim)
                pdf.line_to(xpos+(xdim*amount), ypos+ydim)
                pdf.line_to(xpos+(xdim*amount), ypos)
                pdf.line_to(xpos, ypos)
                pdf.fill
              end
              xpos += (xdim*amount)
            end
            xpos = orig_xpos
            ypos += ydim
          end
        else
          boolean_groups.each do |bar,amount|
            if bar
              pdf.move_to(xpos, ypos)
              pdf.line_to(xpos, ypos+height)
              pdf.line_to(xpos+(xdim*amount), ypos+height)
              pdf.line_to(xpos+(xdim*amount), ypos)
              pdf.line_to(xpos, ypos)
              pdf.fill
            end
            xpos += (xdim*amount)
          end
        end

      end

      pdf
    end


    def length
      two_dimensional? ? encoding.first.length : encoding.length
    end

    def width
      length * xdim
    end

    def height
      two_dimensional? ? (ydim * encoding.length) : (@height || 50)
    end

    def full_width
      width + (margin * 2)
    end

    def full_height
      height + (margin * 2)
    end

    #Margin is used for x and y if not given explicitly, effectively placing the barcode
    #<margin> points from the [left,bottom] of the page.
    #If you define x and y, there will be no margin. And if you don't define margin, it's 0.
    def margin
      @margin || 0
    end

    def x
      @x || margin
    end

    def y
      @y || margin
    end

    def xdim
      @xdim || 1
    end

    def ydim
      @ydim || xdim
    end


  private

    def page_size(xdim, height, margin)
      [width(xdim,margin), height(height,margin)]
    end


  end

end
