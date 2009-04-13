require 'barby/outputter'
require 'RMagick'

module Barby


  #Renders images from barcodes using RMagick
  #
  #Registers the to_png, to_gif, to_jpg and to_image methods
  class RmagickOutputter < Outputter
  
    register :to_png, :to_gif, :to_jpg, :to_image

    attr_accessor :height, :xdim, :ydim, :margin


    #Returns a string containing a PNG image
    def to_png(*a)
      to_blob('png', *a)
    end

    #Returns a string containint a GIF image
    def to_gif(*a)
      to_blob('gif', *a)
    end

    #Returns a string containing a JPEG image
    def to_jpg(*a)
      to_blob('jpg', *a)
    end
    
    def to_blob(format, *a)
      img = to_image(*a)
      blob = img.to_blob{|i| i.format = format }
      img.destroy! if img.respond_to?(:destroy!) # Helps with RMagick memory leak problem
      blob
    end

    #Returns an instance of Magick::Image
    def to_image(opts={})
      with_options opts do
        canvas = Magick::Image.new(full_width, full_height)
        bars = Magick::Draw.new

        x = margin
        y = margin

        if barcode.two_dimensional?
          encoding.each do |line|
            line.split(//).map{|c| c == '1' }.each do |bar|
              if bar
                bars.rectangle(x, y, x+(xdim-1), y+(ydim-1))
              end
              x += xdim
            end
            x = margin
            y += ydim
          end
        else
          booleans.each do |bar|
            if bar
              bars.rectangle(x, y, x+(xdim-1), y+(height-1))
            end
            x += xdim
          end
        end

        bars.draw(canvas)

        canvas
      end
    end


    #The height of the barcode in px
    #For 2D barcodes this is the number of "lines" * ydim
    def height
      barcode.two_dimensional? ? (ydim * encoding.length) : (@height || 100)
    end

    #The width of the barcode in px
    def width
      length * xdim
    end

    #Number of modules (xdims) on the x axis
    def length
      barcode.two_dimensional? ? encoding.first.length : encoding.length
    end

    #X dimension. 1X == 1px
    def xdim
      @xdim || 1
    end

    #Y dimension. Only for 2D codes
    def ydim
      @ydim || xdim
    end

    #The margin of each edge surrounding the barcode in pixels
    def margin
      @margin || 10
    end

    #The full width of the image. This is the width of the
    #barcode + the left and right margin
    def full_width
      width + (margin * 2)
    end

    #The height of the image. This is the height of the
    #barcode + the top and bottom margin
    def full_height
      height + (margin * 2)
    end


  end


end
