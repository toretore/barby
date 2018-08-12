---
layout: default
title: Quick howto
---
This code will print a Code128B barcode in PNG format to STDOUT:

    require 'barby'
    require 'barby/outputter/png_outputter'

    barcode = Barby::Code128B.new('huwawa')
    print barcode.to_png

Barby consists of two main parts: Barcode symbologies and outputters.

### Barcode symbologies

Barcode symbologies convert input data to a common format representing
the "bars" and "spaces" (or 2D "blocks") in a barcode:

    >> Barby::Code128B.new('huwawa').encoding #1D
    => "11010010000100110000101001111001011110010100100101100001111001010010010110000100011011101100011101011"
    >> Barby::DataMatrix.new('huawei').encoding #2D
    => ["10101010101010", "11111001000001", "11010110101100", "11111100100001", "11110111010110", "11110111101001", "11100010110000", "11110100101011", "11011011110100", "11100100011001", "11001100110110", "11010011110111", "11001000101110", "11111111111111"]

### Outputters

Outputters take this representation and turns it into something else like an image or a PDF:

    >> require 'barby/barcode/code_128'
    => true
    require 'barby/barcode'
    => true
    >> barcode = Barby::Code128B.new('hawaii')
    >> outputter = Barby::PngOutputter.new(barcode)
    => #<Barby::PngOutputter:0x007fc7bb20c530 @barcode=hawaii>
    >> outputter.to_png
    => "\x89PNG\r\n\u001A\n\u0000\u0000\u0000\rIHDR\u0000\u0000\u0000y\u0000\u0000\u0000x\u0001\u0000\u0000\u0000\u0000\xFE\xDD`A\u0000\u0000\u0000BIDATx\x9Cc\xFA\x8F\n\u001A\x98\u0018\xD0\xC0\xE0\u00118Sc\x97\xF5h݊\xBD;\xA6\u001F\xF1\xD7\u001AL\u000E\e\u0015\u0018\u0015\u0018\u0015\u0018\u0015\u0018\u0015\u0018\xF1\u0002&-\x87\xA6\xC9\u0005E8{d\xDAl\xBC6\x98\u001C\x86\u0006\u0000\bL\u001Dbz'?\x87\u0000\u0000\u0000\u0000IEND\xAEB`\x82"
    >> File.open('barcode.png', 'w'){|f| f.write outputter.to_png }
    => 123

Most outputters register one or more convenience proxy methods directly on the barcode object:

    >> File.open('barcode.png', 'w'){|f| f.write barcode.to_png } #Note: barcode, not outputter
    => 123

For more information, refer to the [Wiki](https://github.com/toretore/barby/wiki) or [documentation](http://rubydoc.info/github/toretore/barby/frames).
