require 'test_helper'

class BooklandTest < Barby::TestCase
  
  before do
    @isbn = '968-26-1240-3'
    @code = Bookland.new(@isbn)
  end

  it "should not touch the ISBN" do
    @code.isbn.must_equal @isbn
  end

  it "should have an isbn_only" do
    @code.isbn_only.must_equal '968261240'
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
    end

    it "should accept ISBN without number system but with check digit" do
      code = Bookland.new('82-92526-14-9')
      assert code.valid?
      code.data.must_equal '978829252614'
    end

    it "should accept ISBN without number system or check digit" do
      code = Bookland.new('82-92526-14')
      assert code.valid?
      code.data.must_equal '978829252614'
    end

  end

end

