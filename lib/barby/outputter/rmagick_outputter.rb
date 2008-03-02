require 'barby/outputter'
require 'RMagick'

module Barby


  #Renders images from barcodes using RMagick
  class RmagickOutputter < Outputter
  
    register :to_png, :to_gif, :to_jpg, :to_image

    attr_accessor :height, :xdim, :margin


    #Returns a string containing a PNG image
    def to_png(*a)
      to_image(*a).to_blob{|i| i.format ='png' }
    end

    #Returns a string containint a GIF image
    def to_gif(*a)
      to_image(*a).to_blob{|i| i.format ='gif' }
    end

    #Returns a string containing a JPEG image
    def to_jpg(*a)
      to_image(*a).to_blob{|i| i.format = 'jpg' }
    end

    #Returns an instance of Magick::Image
    def to_image(opts={})
      opts.each{|k,v| send("#{k}=", v) if respond_to?("#{k}=") }
      canvas = Magick::Image.new(full_width, full_height)
      bars = Magick::Draw.new

      x = margin
      y = margin
      booleans.each do |bar|
        if bar
          bars.rectangle(x, y, x+(xdim-1), y+height)
        end
        x += xdim
      end

      bars.draw(canvas)

      canvas
    end


    #The height of the barcode in px
    def height
      @height || 100
    end

    #X dimension. 1X == 1px
    def xdim
      @xdim || 1
    end

    #The margin of each edge surrounding the barcode in pixels
    def margin
      @margin || 10
    end

    #The width of the barcode in px
    def width
      barcode.encoding.length * xdim
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
