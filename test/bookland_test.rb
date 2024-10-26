require 'test_helper'
require 'barby/barcode/bookland'

class BooklandTest < Barby::TestCase

  before do
    #        Gr Publ Tit Checksum
    @isbn = '96-8261-240-3'
    @code = Bookland.new(@isbn)
  end

  it "should have the expected data" do
    assert_equal '978968261240', @code.data
  end

  it "should have the expected numbers" do
    assert_equal [9,7,8,9,6,8,2,6,1,2,4,0], @code.numbers
  end

  it "should have the expected checksum" do
    assert_equal 4, @code.checksum
  end

  it "should raise an error when data not valid" do
    assert_raises ArgumentError do
      Bookland.new('1234')
    end
  end

  describe 'ISBN conversion' do

    it "should accept ISBN with number system and check digit" do
      code = Bookland.new('978-82-92526-14-9')
      assert code.valid?
      assert_equal '978829252614', code.data
      code = Bookland.new('979-82-92526-14-9')
      assert code.valid?
      assert_equal '979829252614', code.data
    end

    it "should accept ISBN without number system but with check digit" do
      code = Bookland.new('82-92526-14-9')
      assert code.valid?
      assert_equal '978829252614', code.data #978 is the default prefix
    end

    it "should accept ISBN without number system or check digit" do
      code = Bookland.new('82-92526-14')
      assert code.valid?
      assert_equal '978829252614', code.data
    end

  end

end

