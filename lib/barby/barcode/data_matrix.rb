require 'semacode' #Ruby 1.8: gem install semacode - Ruby 1.9: gem install semacode-ruby19
require 'barby/barcode'

module Barby


  #Uses the semacode library (gem install semacode) to encode DataMatrix barcodes
  class DataMatrix < Barcode2D

    attr_accessor :data


    def initialize(data)
      self.data = data
    end


    def data=(data)
      @data = data
      @encoder = nil
    end

    def encoder
      @encoder ||= ::DataMatrix::Encoder.new(data)
    end


    def encoding
      encoder.data.map{|a| a.map{|b| b ? '1' : '0' }.join }
    end


    def semacode?
      #TODO: Not sure if this is right
      data =~ /^http:\/\//
    end


    def to_s
      data
    end


  end

end
