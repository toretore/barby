require 'barby/outputter'
require 'chunky_png'

module Barby

  # Renders the barcode to a PNG image using chunky_png (gem install chunky_png)
  #
  # Registers the to_png, to_datastream and to_canvas methods
  #
  # Options:
  #
  #   * xdim:         X dimension - bar width                                           [1]
  #   * ydim:         Y dimension - bar height (2D only)                                [1]
  #   * height:       Height of bars (1D only)                                          [100]
  #   * margin:       Size of margin around barcode                                     [0]
  #   * foreground:   Foreground color (see ChunkyPNG::Color - can be HTML color name)  [black]
  #   * background:   Background color (see ChunkyPNG::Color - can be HTML color name)  [white]
  #
  class PngOutputter < Outputter

    register :to_png, :to_image, :to_datastream

    attr_writer :xdim, :ydim, :height, :margin


    #Creates a ChunkyPNG::Image object and renders the barcode on it
    def to_image(opts={})
      with_options opts do
        canvas = ChunkyPNG::Image.new(full_width, full_height, background)

        if barcode.two_dimensional?
          x, y = margin, margin
          booleans.each do |line|
            line.each do |bar|
              if bar
                x.upto(x+(xdim-1)) do |xx|
                  y.upto y+(ydim-1) do |yy|
                    canvas[xx,yy] = foreground
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
                  canvas[xx,yy] = foreground
                end
              end
            end
            x += xdim
          end
        end

        canvas
      end
    end


    #Create a ChunkyPNG::Datastream containing the barcode image
    #
    # :constraints - Value is passed on to ChunkyPNG::Image#to_datastream
    #                E.g. to_datastream(:constraints => {:color_mode => ChunkyPNG::COLOR_GRAYSCALE})
    def to_datastream(*a)
      constraints = a.first && a.first[:constraints] ? [a.first[:constraints]] : []
      to_image(*a).to_datastream(*constraints)
    end


    #Renders the barcode to a PNG image
    def to_png(*a)
      to_datastream(*a).to_s
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


    def background=(c)
      @background = if c.is_a?(String) || c.is_a?(Symbol)
                      ChunkyPNG::Color.html_color(c.to_sym)
                    else
                      c
                    end
    end

    def background
      @background || ChunkyPNG::Color::WHITE
    end

    def foreground=(c)
      @foreground = if c.is_a?(String) || c.is_a?(Symbol)
                      ChunkyPNG::Color.html_color(c.to_sym)
                    else
                      c
                    end
    end

    def foreground
      @foreground || ChunkyPNG::Color::BLACK
    end


    def length
      barcode.two_dimensional? ? encoding.first.length : encoding.length
    end


  end

end
