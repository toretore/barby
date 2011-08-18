require 'test_helper'
require 'barby/barcode/code_25_iata'

class Code25IATATest < Barby::TestCase

  before do
    @data = '0123456789'
    @code = Code25IATA.new(@data)
  end

  it "should have the expected start_encoding" do
    @code.start_encoding.must_equal '1010'
  end

  it "should have the expected stop_encoding" do
    @code.stop_encoding.must_equal '11101'
  end

end
