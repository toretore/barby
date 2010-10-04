require 'barby/outputter'
require 'chunky_png'

module Barby

  #Renders the barcode to a PNG image using the "png" gem (gem install png)
  #
  #Registers the to_png and to_canvas methods
  class ChunkyPngOutputter < Outputter

    register :to_png, :to_canvas

    attr_accessor :xdim, :ydim, :width, :height, :margin


    #Creates a PNG::Canvas object and renders the barcode on it
    def to_canvas(opts={})
      with_options opts do
        canvas = ChunkyPNG::Image.new(full_width, full_height, ChunkyPNG::Color::WHITE)

        if barcode.two_dimensional?
          x, y = margin, margin
          booleans.reverse_each do |line|
            line.each do |bar|
              if bar
                x.upto(x+(xdim-1)) do |xx|
                  y.upto y+(ydim-1) do |yy|
                    canvas[xx,yy] = ChunkyPNG::Color::BLACK
                  end
                end
              end
              x += xdim
            end
            y += ydim
            x = margin
          end
        else
          x, y = margin, margin
          booleans.each do |bar|
            if bar
              x.upto(x+(xdim-1)) do |xx|
                y.upto y+(height-1) do |yy|
                  canvas[xx,yy] = ChunkyPNG::Color::BLACK
                end
              end
            end
            x += xdim
          end
        end

        canvas
      end
    end


    #Renders the barcode to a PNG image
    def to_png(*a)
      to_canvas.to_datastream
    end


    def width
      length * xdim
    end

    def height
      barcode.two_dimensional? ? (ydim * encoding.length) : (@height || 100)
    end

    def full_width
      width + (margin * 2)
    end

    def full_height
      height + (margin * 2)
    end

    def xdim
      @xdim || 1
    end

    def ydim
      @ydim || xdim
    end

    def margin
      @margin || 10
    end

    def length
      barcode.two_dimensional? ? encoding.first.length : encoding.length
    end


  end

end
