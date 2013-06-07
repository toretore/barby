require 'barby/outputter'
require 'prawn'

module Barby

  class PrawnOutputter < Outputter

    register :to_pdf, :annotate_pdf

    attr_accessor :xdim, :ydim, :x, :y, :height, :margin, :unbleed, :use_cursor, :align, :valign, :pdf, :text


    def to_pdf(opts={})
      doc_opts = opts.delete(:document) || {}
      doc_opts[:page_size] ||= 'A4'
      annotate_pdf(Prawn::Document.new(doc_opts), opts).render
    end


    def annotate_pdf(pdf, opts={})
      with_options opts.merge(:pdf => pdf) do
        # Horizontal alignment
        case align
        when :left
          xpos = margin
        when :center
          xpos = (pdf.bounds.width - width - margin*2)/2.0
        when :right
          xpos = pdf.bounds.width - width - margin
        else
          xpos = x
        end

        # Vertical alignment
        case valign
        when :top
          ypos = pdf.bounds.height - height - margin
        when :middle
          ypos = (pdf.bounds.height - full_height)/2.0
        when :bottom
          ypos = margin + text_height
        else
          if use_cursor
            ypos = pdf.y - pdf.bounds.absolute_bottom - height - margin
          else
            ypos = y
          end
        end

        orig_xpos = xpos
        if barcode.two_dimensional?
          boolean_groups.reverse_each do |groups|
            groups.each do |bar,amount|
              if bar
                pdf.move_to(xpos+unbleed, ypos+unbleed)
                pdf.line_to(xpos+unbleed, ypos+ydim-unbleed)
                pdf.line_to(xpos+(xdim*amount)-unbleed, ypos+ydim-unbleed)
                pdf.line_to(xpos+(xdim*amount)-unbleed, ypos+unbleed)
                pdf.line_to(xpos+unbleed, ypos+unbleed)
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
              pdf.move_to(xpos+unbleed, ypos)
              pdf.line_to(xpos+unbleed, ypos+height)
              pdf.line_to(xpos+(xdim*amount)-unbleed, ypos+height)
              pdf.line_to(xpos+(xdim*amount)-unbleed, ypos)
              pdf.line_to(xpos+unbleed, ypos)
              pdf.fill
            end
            xpos += (xdim*amount)
          end
          xpos = orig_xpos
          ypos += height
        end

        if text
          text_left = xpos + (width + margin - text_width) / 2.0
          pdf.draw_text(text, :at => [text_left, ypos - height - text_height])
        end

        pdf.move_down(full_height) if use_cursor

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

    def text_width
      if pdf && text
        pdf.width_of(text)
      else
        0
      end
    end

    def text_height
      if pdf && text
        pdf.height_of(text)
      else
        0
      end
    end

    def full_width
      [width, text_width].max + (margin * 2)
    end

    def full_height
      height + ydim + text_height + (margin * 2)
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

    #Defines an amount to reduce black bars/squares by to account for "ink bleed"
    #If xdim = 3, unbleed = 0.2, a single/width black bar will be 2.6 wide
    #For 2D, both x and y dimensions are reduced.
    def unbleed
      @unbleed || 0
    end

    # If :text => true, then we return the barcode data.  Otherwise, return the specified text
    def text
      (@text == true) ? barcode.data : @text
    end


  private

    def page_size(xdim, height, margin)
      [width(xdim,margin), height(height,margin)]
    end


  end

end
