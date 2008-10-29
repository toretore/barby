require 'barby/outputter'
require 'prawn'

module Barby

  class PrawnOutputter < Outputter

    register :to_pdf, :annotate_pdf


    def to_pdf(opts={})
      opts = options(opts)
      annotate_pdf(Prawn::Document.new(opts[:document]), opts).render
    end


    def annotate_pdf(pdf, opts={})
      opts = options(opts)
      xpos, ypos, height, xdim = opts[:x], opts[:y], opts[:height], opts[:xdim]
      ydim = opts[:ydim] || xdim
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

      pdf
    end


  private

    def default_options
      @default_options ||= {
        :margin => 5,
        :height => 100,
        :xdim => 1
      }
    end

    def options(opts={})
      doc_opts = opts.delete(:document) || {}
      opts = default_options.merge(opts)
      opts[:x] ||= opts[:margin]
      opts[:y] ||= opts[:margin]
      opts[:document] = document_options(opts, doc_opts)
      opts
    end

    def document_options(opts, doc_opts)
      o = doc_opts.dup
      #o[:page_size] ||= page_size(opts[:xdim], opts[:height], opts[:margin])
      #%w(left right top bottom).each{|s| o[:"#{s}_margin"] ||= opts[:margin] }
      o[:page_size] ||= 'A4' #Prawn doesn't currently support custom page sizes
      o
    end

    def page_size(xdim, height, margin)
      [width(xdim,margin), height(height,margin)]
    end

    def width(xdim, margin)
      (xdim * encoding.length) + (margin * 2)
    end

    def height(height, margin)
      height + (margin * 2)
    end


  end

end
