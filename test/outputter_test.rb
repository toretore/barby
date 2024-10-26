require 'test_helper'

class OutputterTest < Barby::TestCase

  before do
    @outputter = Class.new(Outputter)
  end

  it "should be able to register an output method for barcodes" do
    @outputter.register :foo
    Barcode.outputters.must_include(:foo)
    @outputter.register :bar, :baz
    Barcode.outputters.must_include(:bar)
    Barcode.outputters.must_include(:baz)
    @outputter.register :quux => :my_quux
    Barcode.outputters.must_include(:quux)
  end

  describe "Outputter instances" do

    before do
      @barcode = Barcode.new
      class << @barcode; attr_accessor :encoding; end
      @barcode.encoding = '101100111000'
      @outputter = Outputter.new(@barcode)
    end

    it "should have a method 'booleans' which converts the barcode encoding to an array of true,false values" do
      assert_equal @barcode.encoding.length, @outputter.send(:booleans).length
      t, f = true, false
      assert_equal [t,f,t,t,f,f,t,t,t,f,f,f], @outputter.send(:booleans)
    end

    it "should convert 2D encodings with 'booleans'" do
      barcode = Barcode2D.new
      def barcode.encoding; ['101100','110010']; end
      outputter = Outputter.new(barcode)
      assert_equal barcode.encoding.length, outputter.send(:booleans).length
      t, f = true, false
      assert_equal [[t,f,t,t,f,f], [t,t,f,f,t,f]], outputter.send(:booleans)
    end

    it "should have an 'encoding' attribute" do
      assert_equal @barcode.encoding, @outputter.send(:encoding)
    end

    it "should cache encoding" do
      assert_equal @barcode.encoding, @outputter.send(:encoding)
      previous_encoding = @barcode.encoding
      @barcode.encoding = '101010'
      assert_equal previous_encoding, @outputter.send(:encoding)
      assert_equal @barcode.encoding, @outputter.send(:encoding, true)
    end

    it "should have a boolean_groups attribute which collects continuous bars and spaces" do
      t, f = true, false
                                                  # 1     0     11    00    111   000
      assert_equal [[t,1],[f,1],[t,2],[f,2],[t,3],[f,3]], @outputter.send(:boolean_groups)

      barcode = Barcode2D.new
      def barcode.encoding; ['1100', '111000']; end
      outputter = Outputter.new(barcode)
      assert_equal [[[t,2],[f,2]],[[t,3],[f,3]]], outputter.send(:boolean_groups)
    end

    it "should have a with_options method which sets the instance's attributes temporarily while the block gets yielded" do
      class << @outputter; attr_accessor :foo, :bar; end
      @outputter.foo, @outputter.bar = 'humbaba', 'scorpion man'
      @outputter.send(:with_options, :foo => 'horse', :bar => 'donkey') do
        assert_equal 'horse', @outputter.foo
        assert_equal 'donkey', @outputter.bar
      end
      assert_equal 'humbaba', @outputter.foo
      assert_equal 'scorpion man', @outputter.bar
    end

    it "should return the block value on with_options" do
      assert_equal 'donkey', @outputter.send(:with_options, {}){ 'donkey' }
    end

    it "should have a two_dimensional? method which returns true if the barcode is 2d" do
      refute Outputter.new(Barcode1D.new).send(:two_dimensional?)
      assert Outputter.new(Barcode2D.new).send(:two_dimensional?)
    end

    it "should not require the barcode object to respond to two_dimensional?" do
      barcode = Object.new
      def barcode.encoding; "101100111000"; end
      outputter = Outputter.new(barcode)
      assert outputter.send(:booleans)
      assert outputter.send(:boolean_groups)
    end

  end

  describe "Barcode instances" do

    before do
      @outputter = Class.new(Outputter)
      @outputter.register :foo
      @outputter.register :bar => :my_bar
      @outputter.class_eval{ def foo; 'foo'; end; def my_bar; 'bar'; end }
      @barcode = Barcode.new
    end

    it "should respond to registered output methods" do
      assert_equal 'foo', @barcode.foo
      assert_equal 'bar', @barcode.bar
    end

    it "should send arguments to registered method on outputter class" do
      @outputter.class_eval{ def foo(*a); a; end; def my_bar(*a); a; end }
      assert_equal [1,2,3], @barcode.foo(1,2,3)
      assert_equal ['humbaba'], @barcode.bar('humbaba')
    end

    it "should pass block to registered methods" do
      @outputter.class_eval{ def foo(*a, &b); b.call(*a); end }
      assert_equal [1,2,3], @barcode.foo(1,2,3){|*a| a }
    end

    it "should be able to get an instance of a specific outputter" do
      assert @barcode.outputter_for(:foo).is_a?(@outputter)
    end

    it "should be able to get a specific outputter class" do
      assert_equal @outputter, @barcode.outputter_class_for(:foo)
    end

  end

end
