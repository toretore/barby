#encoding: ASCII
require 'barby/barcode/ean_13'

module Barby

  # Bookland barcodes are EAN-13 barcodes with number system
  # 978/979 (hence "Bookland"). The data they encode is an ISBN
  # with its check digit removed. This is a convenience class
  # that takes an ISBN number instead of "pure" EAN-13 data.
  #
  #   #These are all the same:
  #   barcode = Bookland.new('978-0-306-40615-7')
  #   barcode = Bookland.new('978-0-306-40615')
  #   barcode = Bookland.new('0-306-40615-7')
  #   barcode = Bookland.new('0-306-40615')
  #
  # If a prefix is not given, a default of 978 is used.
  class Bookland < EAN13

    # isbn should be an ISBN number string, with or without an EAN prefix and an ISBN checksum
    # non-number formatting like hyphens or spaces are ignored
    #
    # If a prefix is not given, a default of 978 is used.
    def initialize(isbn)
      self.isbn = isbn
      raise ArgumentError, 'data not valid' unless valid?
    end

    def data
      isbn.isbn
    end

    def isbn=(isbn)
      @isbn = ISBN.new(isbn)
    end

    #An instance of ISBN
    def isbn
      @isbn
    end


    # Encapsulates an ISBN number
    #
    # isbn = ISBN.new('978-0-306-40615')
    class ISBN

      DEFAULT_PREFIX = '978'
      PATTERN = /\A(?<prefix>\d\d\d)?(?<number>\d{9})(?<checksum>\d)?\Z/

      attr_reader :number


      # Takes one argument, which is the ISBN string with or without prefix and/or check digit.
      # Non-digit characters like hyphens and spaces are ignored.
      #
      # Prefix is 978 if not given.
      def initialize(isbn)
        self.isbn = isbn
      end


      def isbn=(isbn)
        if match = PATTERN.match(isbn.gsub(/\D/, ''))
          @number = match[:number]
          @prefix = match[:prefix]
        else
          raise ArgumentError, "Not a valid ISBN: #{isbn}"
        end
      end

      def isbn
        "#{prefix}#{number}"
      end

      def isbn_with_checksum
        "#{isbn}#{checksum}"
      end

      def isbn_10
        number
      end

      def isbn_10_with_checksum
        "#{number}#{checksum}"
      end

      def formatted_isbn
        "#{prefix}-#{number}-#{checksum}"
      end

      def formatted_isbn_10
        "#{number}-#{checksum}"
      end


      def prefix
        @prefix || DEFAULT_PREFIX
      end

      def digits
        (prefix+number).split('').map(&:to_i)
      end

      def isbn_10_digits
        number.split('').map(&:to_i)
      end


      # Calculates the ISBN 13-digit checksum following the algorithm from:
      # http://en.wikipedia.org/wiki/International_Standard_Book_Number#ISBN-13_check_digit_calculation
      def checksum
        (10 - (digits.each_with_index.inject(0) do |sum, (digit, index)|
          sum + (digit * (index.even? ? 1 : 3))
        end % 10)) % 10
      end


      ISBN_10_CHECKSUM_MULTIPLIERS = [10,9,8,7,6,5,4,3,2]

      # Calculates the ISBN 10-digit checksum following the algorithm from:
      # http://en.wikipedia.org/wiki/International_Standard_Book_Number#ISBN-10_check_digit_calculation
      def isbn_10_checksum
        isbn_10_digits.zip(ISBN_10_CHECKSUM_MULTIPLIERS).inject(0) do |sum, (digit, multiplier)|
          sum + (digit * multiplier)
        end
      end


      def to_s
        isbn_with_checksum
      end

      def inspect
        "#<#{self.class}:0x#{'%014x' % object_id} #{formatted_isbn}>"
      end


    end#class ISBN


  end#class Bookland


end#module Barby
