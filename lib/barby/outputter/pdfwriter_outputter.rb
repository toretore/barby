require 'barby/outputter'

module Barby

  #Annotates a PDFWriter document with the barcode
  #
  #Registers the annotate_pdf method
  class PDFWriterOutputter < Outputter

    register :annotate_pdf

    attr_accessor :x, :y, :height, :xdim


    #Annotate a PDFWriter document with the barcode
    #
    #Valid options are:
    #
    #x, y   - The point in the document to start rendering from
    #height - The height of the bars in PDF units
    #xdim   - The X dimension in PDF units
    def annotate_pdf(pdf, options={})
      previous_options = options.map{|k,v| [k, send(k)] }
      options.each{|k,v| send("#{k}=", v) if respond_to?("#{k}=") }

      xpos, ypos = x, y
      orig_xpos = xpos

      if barcode.two_dimensional?
        encoding.each do |line|
          widths(line.split(//).map{|c| c == '1' }).each do |array|
            if array.first
              pdf.move_to(xpos, ypos).
                line_to(xpos, ypos+xdim).
                line_to(xpos+(xdim*array.size), ypos+xdim).
                line_to(xpos+(xdim*array.size), ypos).
                line_to(xpos, ypos).
                fill
            end
            xpos += (xdim*array.size)
          end
          xpos = orig_xpos
          ypos += xdim
        end
      else
        widths(booleans).each do |array|
          if array.first
            pdf.move_to(xpos, ypos).
              line_to(xpos, ypos+height).
              line_to(xpos+(xdim*array.size), ypos+height).
              line_to(xpos+(xdim*array.size), ypos).
              line_to(xpos, ypos).
              fill
          end
          xpos += (xdim*array.size)
        end
      end

      previous_options.each{|k,v| send("#{k}=", v) }

      pdf
    end


    def x
      @x || 10
    end

    def y
      @y || 10
    end

    def height
      @height || 50
    end

    def xdim
      @xdim || 1
    end


    private

      def widths(booleans)
        widths = []
        count = nil

        booleans.inject nil do |previous,current|
          if current != previous
            widths << count if count
            count = [current]
          else
            count << current
          end
          current
        end

        widths << count

        widths
      end


  end

end
