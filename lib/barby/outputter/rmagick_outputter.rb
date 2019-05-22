require 'barby/outputter'
require 'rmagick'

module Barby


  # Renders images from barcodes using RMagick
  #
  # Registers the to_png, to_gif, to_jpg and to_image methods
  #
  # Options:
  #
  #   * xdim          -
  #   * ydim          - 2D only
  #   * height        - 1D only
  #   * margin        -
  #   * foreground    - RMagick "colorspec"
  #   * background    - ^
  class RmagickOutputter < Outputter

    register :to_png, :to_gif, :to_jpg, :to_image

    attr_writer :height, :xdim, :ydim, :margin, :foreground, :background


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

      #Release the memory used by RMagick explicitly. Ruby's GC
      #isn't aware of it and can't clean it up automatically
      img.destroy! if img.respond_to?(:destroy!)

      blob
    end

    #Returns an instance of Magick::Image
    def to_image(opts={})
      with_options opts do
        b = background #Capture locally because Magick::Image.new block uses instance_eval
        canvas = Magick::Image.new(full_width, full_height){ self.background_color = b }
        bars = Magick::Draw.new
        bars.fill = foreground

        x1 = margin
        y1 = margin

        if barcode.two_dimensional?
          encoding.each do |line|
            line.split(//).map{|c| c == '1' }.each do |bar|
              if bar
                x2 = x1+(xdim-1)
                y2 = y1+(ydim-1)
                # For single pixels use point
                if x1 == x2 && y1 == y2
                  bars.point(x1,y1)
                else
                  # For single pixel lines, use line
                  if x1 == x2
                    bars.line(x1, y1, x1, y2)
                  elsif y1 == y2
                    bars.line(x1, y1, x2, y1)
                  else
                    bars.rectangle(x1, y1, x2, y2)
                  end
                end
              end
              x1 += xdim
            end
            x1 = margin
            y1 += ydim
          end
        else
          booleans.each do |bar|
            if bar
              x2 = x1+(xdim-1)
              y2 = y1+(height-1)
              # For single pixel width, use line
              if x1 == x2
                bars.line(x1, y1, x1, y2)
              else
                bars.rectangle(x1, y1, x2, y2)
              end
            end
            x1 += xdim
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


    def foreground
      @foreground || 'black'
    end

    def background
      @background || 'white'
    end


  end


end
