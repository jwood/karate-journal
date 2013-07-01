require 'rdoc/markup'
require 'rdoc/markup/to_html'

module EntriesHelper

  def markup(text)
    p = RDoc::Markup.new
    h = RDoc::Markup::ToHtml.new
    p.convert(text, h).html_safe
  end

  def display_search_result_body(search_terms, body, source)
    body = trim_search_result_body(search_terms, body, source)
    body = highlight_search_terms(search_terms, body)
    body.html_safe
  end

  private

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
