require 'barby/barcode'
require 'java'
require 'Pdf417lib'
import 'Pdf417lib'

module Barby
  class Pdf417 < Barcode2D
    DEFAULT_OPTIONS = {
      :options       => 0,
      :y_height      => 3,
      :aspect_ratio  => 0.5, 
      :error_level   => 0,
      :len_codewords => 0,
      :code_rows     => 0,
      :code_columns  => 0
    }

    # Creates a new Pdf417 barcode. The +options+ argument
    # can use the same keys as DEFAULT_OPTIONS. Please consult
    # the source code of Pdf417lib.java for details about values
    # that can be used.
    def initialize(data, options={})
      @pdf417 = Java::Pdf417lib.new
      self.data = data
      DEFAULT_OPTIONS.merge(options).each{|k,v| send("#{k}=", v) }
    end

    def options=(options)
      @options = options
    end

    def y_height=(y_height)
      @pdf417.setYHeight(y_height)
    end

    def aspect_ratio=(aspect_ratio)
      @pdf417.setAspectRatio(aspect_ratio)
    end

    def error_level=(error_level)
      @pdf417.setErrorLevel(error_level)
    end

    def len_codewords=(len_codewords)
      @pdf417.setLenCodewords(len_codewords)
    end

    def code_rows=(code_rows)
      @pdf417.setCodeRows(code_rows)
    end

    def code_columns=(code_columns)
      @pdf417.setCodeColumns(code_columns)
    end

    def data=(data)
      @pdf417.setText(data)
    end

    def encoding
      @pdf417.paintCode()

      cols = (@pdf417.getBitColumns() - 1) / 8 + 1
      enc = []
      row = nil
      @pdf417.getOutBits.each_with_index do |byte, n|
        if n%cols == 0
          row = ""
          enc << row
        end
        row << sprintf("%08b", (byte & 0xff) | 0x100)
      end
      enc
    end
  end
end