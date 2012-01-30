require 'barby/barcode'

module Barby


  #An Outputter creates something from a barcode. That something can be
  #anything, but is most likely a graphical representation of the barcode.
  #Outputters can register methods on barcodes that will be associated with
  #them.
  #
  #The basic structure of an outputter class:
  #
  #  class FooOutputter < Barby::Outputter
  #    register :to_foo
  #    def to_too
  #      do_something_with(barcode.encoding)
  #    end
  #  end
  #
  #Barcode#to_foo will now be available to all barcodes
  class Outputter

    attr_accessor :barcode


    #An outputter instance will have access to a Barcode
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


    def two_dimensional?
      barcode.respond_to?(:two_dimensional?) && barcode.two_dimensional?
    end


    #Converts the barcode's encoding (a string containing 1s and 0s)
    #to true and false values (1 == true == "black bar")
    #
    #If the barcode is 2D, each line will be converted to an array
    #in the same way
    def booleans(reload=false)#:doc:
      if two_dimensional?
        encoding(reload).map{|l| l.split(//).map{|c| c == '1' } }
      else
        encoding(reload).split(//).map{|c| c == '1' }
      end
    end


    #Returns the barcode's encoding. The encoding
    #is cached and can be reloaded by passing true
    def encoding(reload=false)#:doc:
      @encoding = barcode.encoding if reload
      @encoding ||= barcode.encoding
    end


    #Collects continuous groups of bars and spaces (1 and 0)
    #into arrays where the first item is true or false (1 or 0)
    #and the second is the size of the group
    #
    #For example, "1100111000" becomes [[true,2],[false,2],[true,3],[false,3]]
    def boolean_groups(reload=false)
      if two_dimensional?
        encoding(reload).map do |line|
          line.scan(/1+|0+/).map do |group|
            [group[0,1] == '1', group.size]
          end
        end
      else
        encoding(reload).scan(/1+|0+/).map do |group|
          [group[0,1] == '1', group.size]
        end
      end
    end


  private

    #Takes a hash and temporarily sets properties on self (the outputter object)
    #corresponding with the keys to their values. When the block exits, the
    #properties are reset to their original values. Returns whatever the block returns.
    def with_options(options={})
      original_options = options.inject({}) do |origs,pair|
        if respond_to?(pair.first) && respond_to?("#{pair.first}=")
          origs[pair.first] = send(pair.first)
          send("#{pair.first}=", pair.last)
        end
        origs
      end

      rv = yield

      original_options.each do |attribute,value|
        send("#{attribute}=", value)
      end

      rv
    end


  end


end
