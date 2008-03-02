require File.join(File.dirname(__FILE__), '..', 'lib', 'outputter')
include Barby


describe "Outputter classes" do

  before :each do
    @outputter = Class.new(Outputter)
  end

  it "should be able to register an output method for barcodes" do
    @outputter.register :foo
    Barcode.outputters.should include(:foo)
    @outputter.register :bar, :baz
    Barcode.outputters.should include(:bar, :baz)
    @outputter.register :quux => :my_quux
    Barcode.outputters.should include(:quux)
  end

end


describe "Outputter instances" do

  before :each do
    @barcode = Barcode.new
    def @barcode.encoding; '101100111000'; end
  end

  it "should have a method 'booleans' which converts the barcode encoding to an array of true,false values" do
    @outputter = Class.new(Outputter).new(@barcode)
    @outputter.send(:booleans).length.should == @barcode.encoding.length
    t, f = true, false
    @outputter.send(:booleans).should == [t,f,t,t,f,f,t,t,t,f,f,f]
  end

end


describe "Barcode instances" do

  before :all do
    @outputter = Class.new(Outputter)
    @outputter.register :foo
    @outputter.register :bar => :my_bar
    @outputter.class_eval{ def foo; 'foo'; end; def my_bar; 'bar'; end }
    @barcode = Barcode.new
  end

  it "should respond to registered output methods" do
    @barcode.foo.should == 'foo'
    @barcode.bar.should == 'bar'
  end

  it "should send arguments to registered method on outputter class" do
    @outputter.class_eval{ def foo(*a); a; end; def my_bar(*a); a; end }
    @barcode.foo(1,2,3).should == [1,2,3]
    @barcode.bar('humbaba').should == ['humbaba']
  end

  it "should pass block to registered methods" do
    @outputter.class_eval{ def foo(*a, &b); b.call(*a); end }
    @barcode.foo(1,2,3){|*a| a }.should == [1,2,3]
  end

  it "should be able to get an instance of a specific outputter" do
    @barcode.outputter_for(:foo).should be_an_instance_of(@outputter)
  end

  it "should be able to get a specific outputter class" do
    @barcode.outputter_class_for(:foo).should == @outputter
  end

end
