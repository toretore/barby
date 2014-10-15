require 'test_helper'
require 'barby/barcode/bookland'

class BooklandTest < Barby::TestCase

  before do
    #        Gr Publ Tit Checksum
    @isbn = '96-8261-240-3'
    @code = Bookland.new(@isbn)
  end

  it "should have the expected data" do
    @code.data.must_equal '978968261240'
  end

  it "should have the expected numbers" do
    @code.numbers.must_equal [9,7,8,9,6,8,2,6,1,2,4,0]
  end

  it "should have the expected checksum" do
    @code.checksum.must_equal 4
  end

  it "should raise an error when data not valid" do
    lambda{ Bookland.new('1234') }.must_raise ArgumentError
  end

  describe 'ISBN conversion' do

    it "should accept ISBN with number system and check digit" do
      code = Bookland.new('978-82-92526-14-9')
      assert code.valid?
      code.data.must_equal '978829252614'
      code = Bookland.new('979-82-92526-14-9')
      assert code.valid?
      code.data.must_equal '979829252614'
    end

    it "should accept ISBN without number system but with check digit" do
      code = Bookland.new('82-92526-14-9')
      assert code.valid?
      code.data.must_equal '978829252614' #978 is the default prefix
    end

    it "should accept ISBN without number system or check digit" do
      code = Bookland.new('82-92526-14')
      assert code.valid?
      code.data.must_equal '978829252614'
    end

  end

end

