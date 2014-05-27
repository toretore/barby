require 'test_helper'
require 'barby/barcode/code_128'
#require 'barby/outputter/html_outputter'

class HtmlOutputterTest < Barby::TestCase

  class MockCode
    attr_reader :encoding
    def initialize(e)
      @encoding = e
    end
    def two_dimensional?
      encoding.is_a? Array
    end
  end

  before do
    load_outputter('html')
    @barcode = Barby::Code128B.new('BARBY')
    @outputter = HtmlOutputter.new(@barcode)
  end

  it "should register to_html" do
    Barcode.outputters.must_include(:to_html)
  end

  it 'should have the expected start HTML' do
    assert_equal '<table class="barby-barcode"><tbody>', @outputter.start
  end

  it 'should be able to set additional class name' do
    @outputter.class_name = 'humbaba'
    assert_equal '<table class="barby-barcode humbaba"><tbody>', @outputter.start
  end

  it 'should have the expected stop HTML' do
    assert_equal '</tbody></table>', @outputter.stop
  end

  it 'should build the expected cells' do
    assert_equal ['<td class="barby-cell on"></td>', '<td class="barby-cell off"></td>', '<td class="barby-cell off"></td>', '<td class="barby-cell on"></td>'],
      @outputter.cells_for([true, false, false, true])
  end

  it 'should build the expected rows' do
    assert_equal(
      [
        "<tr class=\"barby-row\">#{@outputter.cells_for([true, false]).join}</tr>",
        "<tr class=\"barby-row\">#{@outputter.cells_for([false, true]).join}</tr>",
      ],
      @outputter.rows_for([[true, false],[false, true]])
    )
  end

  it 'should have the expected rows' do
    barcode = MockCode.new('101100')
    outputter = HtmlOutputter.new(barcode)
    assert_equal outputter.rows_for([[true, false, true, true, false, false]]), outputter.rows
    barcode = MockCode.new(['101', '010'])
    outputter = HtmlOutputter.new(barcode)
    assert_equal outputter.rows_for([[true, false, true], [false, true, false]]), outputter.rows
  end

  it 'should have the expected html' do
    assert_equal @outputter.start + @outputter.rows.join + @outputter.stop, @outputter.to_html
  end

end
