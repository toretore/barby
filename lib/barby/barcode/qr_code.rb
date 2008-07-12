$: << File.dirname(__FILE__)+'/../../../vendor/rqrcode/lib'
require 'rqrcode'
require 'barby/barcode'

module Barby


  class QRCode < Barcode2D


    def initialize(*a, &b)
      @rqrcode = RQRCode::QRCode.new(*a, &b)
    end


    def data
      @rqrcode.instance_variable_get('@data')
    end


    def encoding
      @rqrcode.modules.map{|r| r.inject(''){|s,m| s << (m ? '1' : '0') } }
    end


  end


end
