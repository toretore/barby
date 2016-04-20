require 'barby/barcode/code_128'

module Barby


  #DEPRECATED - Use the Code128 class directly instead:
  #
  #  Code128.new("#{Code128::FNC1}#{application_identifier}#{data}")
  #
  #AKA EAN-128, UCC-128
  class GS1128 < Code128

    attr_accessor :application_identifier

    def initialize(data, type, ai)
      warn "DEPRECATED: The GS1128 class has been deprecated, use Code128 directly instead (called from #{caller[0]})"
      self.application_identifier = ai
      super(data, type)
    end


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
