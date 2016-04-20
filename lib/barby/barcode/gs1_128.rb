require 'barby/barcode/code_128'

module Barby


  #AKA EAN-128, UCC-128
  class GS1128 < Code128

    attr_accessor :application_identifier
    attr_reader :partial_data

    def initialize(partial_data, type, ai)
      @partial_data = partial_data
      self.application_identifier = ai
      super("#{FNC1}#{application_identifier}#{partial_data}", type)
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
