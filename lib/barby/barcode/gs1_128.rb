require 'barby/barcode/code_128'

module Barby


  #AKA EAN-128, UCC-128
  class GS1128 < Code128

    attr_accessor :application_identifier

    def initialize(data, type, ai)
      self.application_identifier = ai
      super(data, type)
    end


    #TODO: Not sure this is entirely right
    def data
      FNC1+application_identifier+super
    end

    def partial_data
      @data
    end

    def application_identifier_number
      values[application_identifier]
    end

    def application_identifier_encoding
      encodings[application_identifier_number]
    end

    def to_s
      "(#{application_identifier}) #{partial_data}"
    end


  end


end
