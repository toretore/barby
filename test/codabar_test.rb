require 'test_helper'
require 'barby/barcode/codabar'

class CodabarTest < Barby::TestCase

  describe 'validations' do

    before do
      @valid = Codabar.new('A12345D')
    end

    it "should be valid with alphabet rounded numbers" do
      assert @valid.valid?
    end

    it "should not be valid with unsupported characters" do
      @valid.data = "A12345E"
      refute @valid.valid?
    end

    it "should raise an exception when data is invalid" do
      assert_raises ArgumentError do
        Codabar.new('A12345E')
      end
    end
  end

  describe 'data' do

    before do
      @data = 'A12345D'
      @code = Codabar.new(@data)
    end

    it "should have the same data as was passed to it" do
      assert_equal @data, @code.data
    end
  end

  describe 'encoding' do

    before do
      @code = Codabar.new('A01D')
      @code.white_narrow_width = 1
      @code.black_narrow_width = 1
      @code.wide_width_rate = 2
      @code.spacing = 2
    end

    it "should have the expected encoding" do
      assert_equal [
        "1011001001", # A
        "101010011", # 0
        "101011001", # 1
        "1010011001", # D
      ].join("00"),
      @code.encoding
    end
  end
end

