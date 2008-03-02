require File.join(File.dirname(__FILE__), '..', 'outputter')

module Barby

  class PDFWriterOutputter < Outputter

    register :annotate_pdf

    attr_accessor :x, :y, :height, :xdim


    def annotate_pdf(pdf, options={})
      previous_options = options.map{|k,v| [k, send(k)] }
      options.each{|k,v| send("#{k}=", v) if respond_to?("#{k}=") }

      xpos, ypos = x, y

      widths.each do |array|
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

    def widths
      widths = []
      count = nil
      
      booleans.inject nil do |last,current|
        if current != last
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
