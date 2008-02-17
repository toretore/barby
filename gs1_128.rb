require File.join(File.dirname(__FILE__), 'code_128')

module Barby


  class GS1128 < Code128

    attr_accessor :application_identifier

    def initialize(data, type, ai)
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


  end


end
