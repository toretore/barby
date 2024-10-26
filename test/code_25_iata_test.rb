require 'test_helper'
require 'barby/barcode/code_25_iata'

class Code25IATATest < Barby::TestCase

  before do
    @data = '0123456789'
    @code = Code25IATA.new(@data)
  end

  it "should have the expected start_encoding" do
    assert_equal '1010', @code.start_encoding
  end

  it "should have the expected stop_encoding" do
    assert_equal '11101', @code.stop_encoding
  end

end
