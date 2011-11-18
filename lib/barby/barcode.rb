module Barby


  #The base class for all barcodes. It includes some method_missing magic
  #that is used to find registered outputters.
  #
  #The only interface requirement of a barcode class is that is has an encoding
  #method that returns a string consisting of 1s and 0s representing the barcode's
  #"black" and "white" parts. One digit is the width of the "X dimension"; that is,
  #"101100" represents a single-width bar followed by a single-width space, then
  #a bar and a space twice that width.
  #
  #Example implementation:
  #
  # class StaticBarcode < Barby::Barcode1D
  #  def encoding
  #   '101100111000111100001'
  #  end
  # end
  # 
  # require 'barby/outputter/ascii_outputter'
  # puts StaticBarcode.new.to_ascii(:height => 3)
  #
  # # ##  ###   ####    #
  # # ##  ###   ####    #
  # # ##  ###   ####    #
  #
  #2D implementation:
  #
  # class Static2DBarcode < Barby::Barcode2D
  #   def encoding
  #     ['1010101', '010101110', '0001010100']
  #   end
  # end
  class Barcode
  
    
    #Every barcode must have an encoding method. This method returns
    #a string containing a series of 1 and 0, representing bars and
    #spaces. One digit is the width of one "module" or X dimension.
    #
    #If the barcode is 2D, it returns an array of strings representing
    #each line in the barcode
    def encoding
      raise NotImplementedError, 'Every barcode should implement this method'
    end


    #Is this barcode valid?
    def valid?
      false
    end


    def to_s
      self.class.name.split('::').last
    end


    #Is this barcode 2D?
    def two_dimensional?
      is_a? Barcode2D
    end


    def method_missing(name, *args, &b)#:nodoc:
      #See if an outputter has registered this method
      if self.class.outputters.include?(name)
        klass, method_name = self.class.outputters[name]
        klass.new(self).send(method_name, *args, &b)
      else
        super
      end
    end


    #Returns an instantiated outputter for +name+ if any outputter
    #has registered that name
    def outputter_for(name, *a, &b)
      outputter_class_for(name).new(self, *a, &b)
    end

    #Get the outputter class object for +name+
    def outputter_class_for(name)
      self.class.outputters[name].first
    end


    class << self

      def outputters
        @@outputters ||= {}
      end

      #Registers an outputter with +name+ so that a call to
      #+name+ on a Barcode instance will be delegated to this outputter
      def register_outputter(name, klass, method_name)
        outputters[name] = [klass, method_name]
      end

    end

  end


  #Most barcodes are one-dimensional. They have bars.
  class Barcode1D < Barcode
  end

  #2D barcodes are 1D barcodes stacked on top of each other.
  #Their encoding method must return an array of strings
  class Barcode2D < Barcode
  end


end
