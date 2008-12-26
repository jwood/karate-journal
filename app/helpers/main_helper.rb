module MainHelper

  require 'rdoc/markup/simple_markup'
  require 'rdoc/markup/simple_markup/to_html'
  
  #----------------------------------------------------------------------------#
  # Layout the specified entries in a table
  #----------------------------------------------------------------------------#
  def create_table_for(entries)
    table_html =  "\n"
    table_html += "<table>\n"
    table_html += "  <tr>\n"
  
    row_count = 0
    entries.each do |entry|
      if row_count > 0 && row_count % 4 == 0
        row_count = 0
        table_html += "  </tr>\n"
        table_html += "  <tr>\n"
      end
      
      row_count += 1
      table_html += "    <td>"
      table_html += link_to(entry.title, :action => 'show_entry', :id => entry)
      table_html += "</td>\n"
    end

    table_html += "  </tr>\n"
    table_html += "</table>\n"
    table_html    
  end
  
  #----------------------------------------------------------------------------#
  # Markup presentation text for display
  #----------------------------------------------------------------------------#
  def markup(text)
    p = SM::SimpleMarkup.new
    h = SM::ToHtml.new
    p.convert(text, h)
  end
  
  #----------------------------------------------------------------------------#
  # Prepare the search result body for display
  #----------------------------------------------------------------------------#
  def display_search_result_body(search_terms, body, source)
    body = trim_search_result_body(search_terms, body, source)
    body = highlight_search_terms(search_terms, body)
    body
  end
  
  #----------------------------------------------------------------------------
  private
  #----------------------------------------------------------------------------

  #----------------------------------------------------------------------------#
  # Trim the search result body to an acceptable length
  #----------------------------------------------------------------------------#
  def trim_search_result_body(search_terms, body, source)
    pre_post_size = 30
    max_len = 500
    
    new_body = ""
    search_terms.each do |term|
      offset = body.upcase.index(term.upcase)
      while (!offset.nil?)
        if offset > pre_post_size
          new_body << "..."
          new_body << body.slice(offset - pre_post_size, term.size + (pre_post_size * 2))
        else
          new_body << body.slice(0, offset + term.size + pre_post_size)
        end

        new_body << "..."
        offset = body.upcase.index(term.upcase, offset + 1)
      end

      new_body << "Source: #{source}" if source.upcase.include?(term.upcase)
    end

    new_body.slice(0, max_len)
  end
  
  #----------------------------------------------------------------------------#
  # Highlight the search terms in the search result body
  #----------------------------------------------------------------------------#
  def highlight_search_terms(search_terms, body)
    search_terms.each do |term| 
      regex = ""
      term.each_char { |char| regex << "[" + char.upcase + "|" + char.downcase + "]" }
      while body =~ /[^highlight">](#{regex})/
        body.gsub!($1, "<span class=\"highlight\">#{$1}</span>")
      end
    end
    body
  end

end
