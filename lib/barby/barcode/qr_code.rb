require 'rqrcode'
require 'barby/barcode'

module Barby


  #QrCode is a thin wrapper around the RQRCode library
  class QrCode < Barcode2D

    #Maximum sizes for each correction level for binary data
    #It's an array
    SIZES = {
            #L   M   Q   H
      1  => [17, 14, 11, 7],          2  => [32, 26, 20, 14],
      3  => [53, 42, 32, 24],         4  => [78, 62, 46, 34],
      5  => [106, 84, 60, 44],        6  => [134, 106, 74, 58],
      7  => [154, 122, 86, 64],       8  => [192, 152, 108, 84],
      9  => [230, 180, 130, 98],      10 => [271, 213, 151, 119],
      11 => [321, 251, 177, 137],     12 => [367, 287, 203, 155],
      13 => [425, 331, 241, 177],     14 => [458, 362, 258, 194],
      15 => [520, 412, 292, 220],     16 => [586, 450, 322, 250],
      17 => [644, 504, 364, 280],     18 => [718, 560, 394, 310],
      19 => [792, 624, 442, 338],     20 => [858, 666, 482, 382],
      21 => [929, 711, 509, 403],     22 => [1003, 779, 565, 439],
      23 => [1091, 857, 611, 461],    24 => [1171, 911, 661, 511],
      25 => [1273, 997, 715, 535],    26 => [1367, 1059, 751, 593],
      27 => [1465, 1125, 805, 625],   28 => [1528, 1190, 868, 658],
      29 => [1628, 1264, 908, 698],   30 => [1732, 1370, 982, 742],
      31 => [1840, 1452, 1030, 790],  32 => [1952, 1538, 1112, 842],
      33 => [2068, 1628, 1168, 898],  34 => [2188, 1722, 1228, 958],
      35 => [2303, 1809, 1283, 983],  36 => [2431, 1911, 1351, 1051],
      37 => [2563, 1989, 1423, 1093], 38 => [2699, 2099, 1499, 1139],
      39 => [2809, 2213, 1579, 1219], 40 => [2953, 2331, 1663, 1273]
    }.sort

    LEVELS = { :l => 0, :m => 1, :q => 2, :h => 3 }

    attr_reader :data
    attr_writer :level, :size


    def initialize(data, options={})
      self.data = data
      options.each{|k,v| send("#{k}=", v) }
      raise(ArgumentError, "data too large") unless size
    end


    def data=(data)
      @data = data
    end


    def encoding
      rqrcode.modules.map{|r| r.inject(''){|s,m| s << (m ? '1' : '0') } }
    end


    #Error correction level
    #Can be one of [:l, :m, :q, :h] (7%, 15%, 25%, 30%)
    def level
      @level || :l
    end


    def size
      #@size is only used for manual override, if it's not set
      #manually the size is always dynamic, calculated from the
      #length of the data
      return @size if @size

      level_index = LEVELS[level]
      length = data.length
      found_size = nil
      SIZES.each do |size,max_values|
        if max_values[level_index] >= length
          found_size = size
          break
        end
      end
      found_size
    end


    def to_s
      data[0,20]
    end


  private
  
    #Generate an RQRCode object with the available values
    def rqrcode
      RQRCode::QRCode.new(data, :level => level, :size => size)
    end


  end


end
