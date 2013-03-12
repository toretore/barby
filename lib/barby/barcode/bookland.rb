#encoding: ASCII
require 'barby/barcode/ean_13'

module Barby

  #Bookland barcodes are EAN-13 barcodes with number system
  #978 (hence "Bookland"). The data they encode is an ISBN
  #with its check digit removed. This is a convenience class
  #that takes an ISBN no instead of "pure" EAN-13 data.
  class Bookland < EAN13

    BOOKLAND_NUMBER_SYSTEM = '978'

    attr_accessor :isbn

    def initialize(isbn)
      self.isbn = isbn
      raise ArgumentError, 'data not valid' unless valid?
    end

    def data
      BOOKLAND_NUMBER_SYSTEM+isbn_only
    end

    #Removes any non-digit characters, number system and check digit
    #from ISBN, so "978-82-92526-14-9" would result in "829252614"
    def isbn_only
      s = isbn.gsub(/[^0-9]/, '')
      if s.size > 10#Includes number system
        s[3,9]
      else#No number system, may include check digit
        s[0,9]
      end
    end

  end

end
