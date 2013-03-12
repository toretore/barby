require 'barby/outputter'

module Barby

  # Outputs an HTML <table> containing cells for each module in the barcode.
  #
  # This does NOT include any styling, you're expected to add the relevant
  # CSS yourself. The markup is simple: One <table> with class 'barby-barcode',
  # one or more <tr class="barby-row"> inside a <tbody> each containing
  # <td class="barby-cell"> for each module with the additional class "on" or "off".
  #
  # Example, let's say the barcode.encoding == ['101', '010'] :
  #
  #   <table class="barby-barcode">
  #     <tbody>
  #        <tr class="barby-row">
  #          <td class="barby-cell on"></td>
  #          <td class="barby-cell off"></td>
  #          <td class="barby-cell on"></td>
  #        </tr>
  #        <tr class="barby-row">
  #          <td class="barby-cell off"></td>
  #          <td class="barby-cell on"></td>
  #          <td class="barby-cell off"></td>
  #        </tr>
  #     </tbody>
  #   </table>
  #
  # You could then style this with:
  #
  #   table.barby-barcode { border-spacing: 0; }
  #   tr.barby-row {}
  #   td.barby-cell { width: 3px; height: 3px; }
  #   td.barby-cell.on { background: #000; }
  #
  # Options:
  #
  #   :class_name - A class name that will be added to the <table> in addition to barby-barcode
  class HtmlOutputter < Outputter

    register :to_html

    attr_accessor :class_name


    def to_html(options = {})
      with_options options do
        start + rows.join + stop
      end
    end


    def rows
      if barcode.two_dimensional?
        rows_for(booleans)
      else
        rows_for([booleans])
      end
    end


    def rows_for(boolean_groups)
      boolean_groups.map{|g| row_for(cells_for(g)) }
    end

    def cells_for(booleans)
      booleans.map{|b| b ? on_cell : off_cell }
    end

    def row_for(cells)
      "<tr class=\"barby-row\">#{cells.join}</tr>"
    end

    def on_cell
      '<td class="barby-cell on"></td>'
    end

    def off_cell
      '<td class="barby-cell off"></td>'
    end

    def start
      '<table class="barby-barcode'+(class_name ? " #{class_name}" : '')+'"><tbody>'
    end

    def stop
      '</tbody></table>'
    end


  end

end
