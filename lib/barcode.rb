module Barby


  class Barcode
  
    
    #Every barcode must have an encoding method. This method returns
    #a string containing a series of 1 and 0, representing bars and
    #spaces. One digit is the width of one "module" or X dimension.
    def encoding
      raise NotImplementedError, 'Every barcode should implement this method'
    end


    #Is this barcode valid?
    def valid?
      false
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


  class Barcode1D < Barcode
  end

  class Barcode2D < Barcode
  end


end
