require 'test_helper'
require 'barby/barcode/data_matrix'

class DataMatrixTest < Barby::TestCase

  before do
    @data = "humbaba"
    @code = Barby::DataMatrix.new(@data)
  end

  it "should have the expected encoding" do
    assert_equal [
      "10101010101010",
      "10111010000001",
      "11100101101100",
      "11101001110001",
      "11010101111110",
      "11100101100001",
      "11011001011110",
      "10011011010011",
      "11011010000100",
      "10101100101001",
      "11011100001100",
      "10101110110111",
      "11000001010100",
      "11111111111111",
    ],
    @code.encoding
  end

  it "should return data on to_s" do
    assert_equal @data, @code.to_s
  end

  it "should be able to change its data" do
    prev_encoding = @code.encoding
    @code.data = "after eight"
    refute_equal prev_encoding, @code.encoding
  end

end
