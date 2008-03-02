require 'barby/barcode'

module Barby


  #An Outputter creates something from a barcode. That something can be
  #anything, but is most likely a graphical representation of the barcode.
  #Outputters can register methods on barcodes that will be associated with
  #them.
  #
  #Yes, it needs a better name.
  class Outputter

    attr_accessor :barcode


    def initialize(barcode)
      self.barcode = barcode
    end

  
    #Register one or more handler methods with this outputter
    #Barcodes will then be able to use these methods to get the output
    #from the outputter. For example, if you have an ImageOutputter,
    #you could do:
    #
    #register :to_png, :to_gif
    #
    #You could then do aBarcode.to_png and get the result of that method.
    #The class which registers the method will receive the barcode as the only
    #argument, and the default implementation of initialize puts that into
    #the +barcode+ accessor.
    #
    #You can also have different method names on the barcode and the outputter
    #by providing a hash:
    #
    #register :to_png => :create_png, :to_gif => :create_gif
    def self.register(*method_names)
      if method_names.first.is_a? Hash
        method_names.first.each do |name, method_name|
          Barcode.register_outputter(name, self, method_name)
        end
      else
        method_names.each do |name|
          Barcode.register_outputter(name, self, name)
        end
      end
    end


  private

    #Converts the barcode's encoding (a string containing 1s and 0s)
    #to true and false values (1 == true == "black bar")
    def booleans
      barcode.encoding.split(//).map{|c| c == '1' }
    end


  end


end
