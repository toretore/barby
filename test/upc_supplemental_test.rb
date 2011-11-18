require 'test_helper'
require 'barby/barcode/upc_supplemental'

class UpcSupplementalTest < Barby::TestCase

  it 'should be valid with 2 or 5 digits' do
    assert UPCSupplemental.new('12345').valid?
    assert UPCSupplemental.new('12').valid?
  end

  it 'should not be valid with any number of digits other than 2 or 5' do
    refute UPCSupplemental.new('1234').valid?
    refute UPCSupplemental.new('123').valid?
    refute UPCSupplemental.new('1').valid?
    refute UPCSupplemental.new('123456').valid?
    refute UPCSupplemental.new('123456789012').valid?
  end

  it 'should not be valid with non-digit characters' do
    refute UPCSupplemental.new('abcde').valid?
    refute UPCSupplemental.new('ABC').valid?
    refute UPCSupplemental.new('1234e').valid?
    refute UPCSupplemental.new('!2345').valid?
    refute UPCSupplemental.new('ab').valid?
    refute UPCSupplemental.new('1b').valid?
    refute UPCSupplemental.new('a1').valid?
  end
  
  describe 'checksum for 5 digits' do
    
    it 'should have the expected odd_digits' do
      UPCSupplemental.new('51234').odd_digits.must_equal [4,2,5]
      UPCSupplemental.new('54321').odd_digits.must_equal [1,3,5]
      UPCSupplemental.new('99990').odd_digits.must_equal [0,9,9]
    end

    it 'should have the expected even_digits' do
      UPCSupplemental.new('51234').even_digits.must_equal [3,1]
      UPCSupplemental.new('54321').even_digits.must_equal [2,4]
      UPCSupplemental.new('99990').even_digits.must_equal [9,9]
    end

    it 'should have the expected odd and even sums' do
      UPCSupplemental.new('51234').odd_sum.must_equal 33
      UPCSupplemental.new('54321').odd_sum.must_equal 27
      UPCSupplemental.new('99990').odd_sum.must_equal 54

      UPCSupplemental.new('51234').even_sum.must_equal 36
      UPCSupplemental.new('54321').even_sum.must_equal 54
      UPCSupplemental.new('99990').even_sum.must_equal 162
    end

    it 'should have the expected checksum' do
      UPCSupplemental.new('51234').checksum.must_equal 9
      UPCSupplemental.new('54321').checksum.must_equal 1
      UPCSupplemental.new('99990').checksum.must_equal 6
    end
    
  end
  
  describe 'checksum for 2 digits' do
    
    it 'should have the expected checksum' do
      UPCSupplemental.new('51').checksum.must_equal 3
      UPCSupplemental.new('21').checksum.must_equal 1
      UPCSupplemental.new('99').checksum.must_equal 3
    end
    
  end
  
  describe 'encoding' do

    before do
      @data = '51234'
      @code = UPCSupplemental.new(@data)
    end

    it 'should have the expected encoding' do
      #                                                START 5          1          2          3          4
      UPCSupplemental.new('51234').encoding.must_equal '1011 0110001 01 0011001 01 0011011 01 0111101 01 0011101'.tr(' ', '')
      #                                                      9          9          9          9          0
      UPCSupplemental.new('99990').encoding.must_equal '1011 0001011 01 0001011 01 0001011 01 0010111 01 0100111'.tr(' ', '')
      #                                             START 5          1
      UPCSupplemental.new('51').encoding.must_equal '1011 0111001 01 0110011'.tr(' ', '')
      #                                                   2          2
      UPCSupplemental.new('22').encoding.must_equal '1011 0011011 01 0010011'.tr(' ', '')
    end

    it 'should be able to change its data' do
      prev_encoding = @code.encoding
      @code.data = '99990'
      @code.encoding.wont_equal prev_encoding
      #                               9          9          9          9          0
      @code.encoding.must_equal '1011 0001011 01 0001011 01 0001011 01 0010111 01 0100111'.tr(' ', '')
      prev_encoding = @code.encoding
      @code.data = '22'
      @code.encoding.wont_equal prev_encoding
      #                               2          2
      @code.encoding.must_equal '1011 0011011 01 0010011'.tr(' ', '')
    end

  end

end





