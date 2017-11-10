# Barby
Barby is a Ruby library that generates barcodes in a variety of symbologies.

Its functionality is split into _barcode_ and "_outputter_" objects:
  * [`Barby::Barcode` objects] [symbologies] turn data into a binary representation for a given symbology.
  * [`Barby::Outputter`] [outputters] then takes this representation and turns it into images, PDF, etc.

You can easily add a symbology without having to worry about graphical
representation. If it can be represented as the usual 1D or 2D matrix of
lines or squares, outputters will do that for you.

Likewise, you can easily add an outputter for a format that doesn't have one
yet, and it will work with all existing symbologies.

For more information, check out [the Barby wiki][wiki].


### New require policy

Barcode symbologies are no longer required automatically, so you'll have to
require the ones you need.

If you need EAN-13, `require 'barby/barcode/ean_13'`. Full list of symbologies and filenames below.

## Example

```ruby
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/ascii_outputter'

barcode = Barby::Code128B.new('BARBY')

puts barcode.to_ascii #Implicitly uses the AsciiOutputter

## #    #  #   # ##   # #   ##   ##   # ### #   # ##   ### ## #   ## ### ### ##   ### # ##
## #    #  #   # ##   # #   ##   ##   # ### #   # ##   ### ## #   ## ### ### ##   ### # ##
## #    #  #   # ##   # #   ##   ##   # ### #   # ##   ### ## #   ## ### ### ##   ### # ##
## #    #  #   # ##   # #   ##   ##   # ### #   # ##   ### ## #   ## ### ### ##   ### # ##
## #    #  #   # ##   # #   ##   ##   # ### #   # ##   ### ## #   ## ### ### ##   ### # ##
## #    #  #   # ##   # #   ##   ##   # ### #   # ##   ### ## #   ## ### ### ##   ### # ##
## #    #  #   # ##   # #   ##   ##   # ### #   # ##   ### ## #   ## ### ### ##   ### # ##
## #    #  #   # ##   # #   ##   ##   # ### #   # ##   ### ## #   ## ### ### ##   ### # ##
## #    #  #   # ##   # #   ##   ##   # ### #   # ##   ### ## #   ## ### ### ##   ### # ##
## #    #  #   # ##   # #   ##   ##   # ### #   # ##   ### ## #   ## ### ### ##   ### # ##
          B          A          R          B          Y
```

## Supported symbologies

```ruby
require 'barby/barcode/<filename>'
```

| Name                                | Filename              | Dependencies                       |
| ----------------------------------- | --------------------- | ---------------------------------- |
| Code 25                             | `code_25`             | ─                                  |
| ├─ Interleaved                      | `code_25_interleaved` | ─                                  |
| └─ IATA                             | `code_25_iata`        | ─                                  |
| Code 39                             | `code_39`             | ─                                  |
| └─ Extended                         | `code_39`             | ─                                  |
| Code 93                             | `code_93`             | ─                                  |
| Code 128 (A, B, and C)              | `code_128`            | ─                                  |
| └─ GS1 128                          | `gs1_128`             | ─                                  |
| EAN-13                              | `ean_13`              | ─                                  |
| ├─ Bookland                         | `bookland`            | ─                                  |
| └─ UPC-A                            | `ean_13`              | ─                                  |
| EAN-8                               | `ean_8`               | ─                                  |
| UPC/EAN supplemental, 2 & 5 digits  | `upc_supplemental`    | ─                                  |
| QR Code                             | `qr_code`             | `rqrcode`                          |
| DataMatrix (Semacode)               | `data_matrix`         | `semacode` or `semacode-ruby19`    |
| PDF417                              | `pdf_417`             | JRuby                              |


## Outputters

```ruby
require 'barby/outputter/<filename>_outputter'
```

| filename    | dependencies  |
| ----------- | ------------- |
| `ascii`     | ─             |
| `cairo`     | cairo         |
| `html`      | ─             |
| `pdfwriter` | ─             |
| `png`       | chunky_png    |
| `prawn`     | prawn         |
| `rmagick`   | rmagick       |
| `svg`       | ─             |

### Formats supported by outputters

* Text (mostly for testing)
* PNG, JPEG, GIF
* PS, EPS
* SVG
* PDF
* HTML

---

For more information, check out [the Barby wiki][wiki].


  [wiki]: https://github.com/toretore/barby/wiki
  [symbologies]: https://github.com/toretore/barby/wiki/Symbologies
  [outputters]: https://github.com/toretore/barby/wiki/Outputters
