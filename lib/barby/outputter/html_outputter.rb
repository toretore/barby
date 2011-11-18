require 'barby/outputter'

module Barby

  # Outputs an HTML representation of the barcode.
  # 
  # Registers to_html
  # 
  # Allowed options include.
  #   :width        - Applied to parent element's style attribute. Default 100.
  #   :height       - Applied to parent element's style attribute. Default 100.
  #   :css          - Include Barby::HtmlOutputter.css in output's style tag. If you pass false
  #                   you can include the output of Barby::HtmlOutputter.css in single place like 
  #                   your own stylesheet on once on the page. Default true.
  #   :parent_style - Include inline style for things like width and height on parent element. 
  #                   Useful if you want to style these attributes elsewhere globally. Default true.
  class HtmlOutputter < Outputter

    register :to_html
    
    def self.css
      <<-CSS
        table.barby_code {
          border: 0 none transparent !important;
          border-collapse: collapse !important;
        }
        table.barby_code tr.barby_row {
          border: 0 none transparent !important;
          border-collapse: collapse !important;
          margin: 0 !important;
          padding: 0 !important;
        }
        table.barby_code tr.barby_row td { border: 0 none transparent !important; }
        table.barby_code tr.barby_row td.barby_black { background-color: black !important; }
        table.barby_code tr.barby_row td.barby_white { background-color: white !important; }
      CSS
    end
    
    def to_html(options={})
      default_options = {:width => 100, :height => 100, :css => true, :parent_style => :true}
      options = default_options.merge(options)
      elements = if barcode.two_dimensional?
                   booleans.map do |bools|
                     line_to_elements_row(bools, options)
                   end.join("\n")
                 else
                   line_to_elements_row(booleans, options)
                 end
      html = %|<#{parent_element} class="barby_code" #{parent_style_attribute(options)}>\n#{elements}\n</#{parent_element}>|
      options[:css] ? "<style>#{self.class.css}</style>\n#{html}" : html
    end


  private

    def line_to_elements_row(bools, options)
      elements = bools.map{ |b| b ? black_tag : white_tag }.join
      Array(%|<#{row_element} class="barby_row">#{elements}</#{row_element}>|)
    end
    
    def black_tag
      '<td class="barby_black"></td>'
    end
    
    def white_tag
      '<td class="barby_white"></td>'
    end
    
    def row_element
      'tr'
    end
    
    def parent_element
      'table'
    end
    
    def parent_style_attribute(options)
      return unless options[:parent_style]
      s = ''
      s << "width: #{options[:width]}px; " if options[:width]
      s << "height: #{options[:height]}px; " if options[:height]
      s.strip!
      s.empty? ? nil : %|style="#{s}"|
    end

  end

end
