require File.join(File.dirname(__FILE__), 'spec_helper')
require 'barby/barcode/code_93'
include Barby

describe Code93 do

  before :each do
    @data = 'TEST93'
    @code = Code93.new(@data)
  end

  it "should return the same data we put in" do
    @code.data.should == @data
  end

  it "should have the expected characters" do
    @code.characters.should == @data.split(//)
  end

  it "should have the expected start_encoding" do
    @code.start_encoding.should == '101011110'
  end

  it "should have the expected stop_encoding" do
    #                              STOP     TERM
    @code.stop_encoding.should == '1010111101'
  end

  it "should have the expected encoded characters" do
    #                                     T         E         S         T         9         3
    @code.encoded_characters.should == %w(110100110 110010010 110101100 110100110 100001010 101000010)
  end

  it "should have the expected data_encoding" do
    #                              T        E        S        T        9        3
    @code.data_encoding.should == "110100110110010010110101100110100110100001010101000010"
  end

  it "should have the expected data_encoding_with_checksums" do
    #                                             T        E        S        T        9        3        + (C)    6 (K)
    @code.data_encoding_with_checksums.should == "110100110110010010110101100110100110100001010101000010101110110100100010"
  end

  it "should have the expected encoding" do
    #                         START    T        E        S        T        9        3        + (C)    6 (K)    STOP     TERM
    @code.encoding.should == "1010111101101001101100100101101011001101001101000010101010000101011101101001000101010111101"
  end

  it "should have the expected checksum_values" do
    @code.checksum_values.should == [29, 14, 28, 29, 9, 3].reverse #!
  end

  it "should have the expected c_checksum" do
    @code.c_checksum.should == 41 #calculate this first!
  end

  it "should have the expected c_checksum_character" do
    @code.c_checksum_character.should == '+'
  end

  it "should have the expected c_checksum_encoding" do
    @code.c_checksum_encoding.should == '101110110'
  end

  it "should have the expected checksum_values_with_c_checksum" do
    @code.checksum_values_with_c_checksum.should == [29, 14, 28, 29, 9, 3, 41].reverse #!
  end

  it "should have the expected k_checksum" do
    @code.k_checksum.should == 6 #calculate this first!
  end

  it "should have the expected k_checksum_character" do
    @code.k_checksum_character.should == '6'
  end

  it "should have the expected k_checksum_encoding" do
    @code.k_checksum_encoding.should == '100100010'
  end

  it "should have the expected checksums" do
    @code.checksums.should == [41, 6]
  end

  it "should have the expected checksum_characters" do
    @code.checksum_characters.should == ['+', '6']
  end

  it "should have the expected checksum_encodings" do
    @code.checksum_encodings.should == %w(101110110 100100010)
  end

  it "should have the expected checksum_encoding" do
    @code.checksum_encoding.should == '101110110100100010'
  end

  it "should be valid" do
    @code.should be_valid
  end

  it "should not be valid when not in extended mode" do
    @code.data = 'not extended'
  end

end
