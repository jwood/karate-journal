require 'rdoc/markup'
require 'rdoc/markup/to_html'

module EntriesHelper

  def markup(text)
    p = RDoc::Markup.new
    h = RDoc::Markup::ToHtml.new
    p.convert(text, h)
  end

  def display_search_result_body(search_terms, body, source)
    body = trim_search_result_body(search_terms, body, source)
    body = highlight_search_terms(search_terms, body)
    body
  end

  def render_fragments(entry)
    fragments =  render_body_fragments(entry)
    fragments << render_line_fragments(entry)

    unless fragments.empty?
      "<h2>From Other Entries</h2>\n#{fragments}<hr />\n"
    else
      ""
    end
  end

  private

  def render_body_fragments(entry)
    text = ""
    body_fragments = entry.body_fragments
    unless body_fragments.empty?
      body_fragments.each do |fragment|
        text << "From " + link_to("#{fragment[:source].title}", entry_path(fragment[:source]))
        text << "<div class='fragment'>\n"
        text << markup(fragment[:fragment])
        text << "</div>\n"
      end
    end
    text
  end

  def render_line_fragments(entry)
    text = ""
    line_fragments = entry.line_fragments
    unless line_fragments.empty?
      text = "<ul>\n"
      line_fragments.each do |fragment|
        text << "<li>#{markup(fragment[:fragment]).sub(/<\/p>$/, "")} - <small>" +
          link_to("#{fragment[:source].title}", entry_path(fragment[:source])) + "</small></li>\n"
      end
      text << "</ul>\n"
    end
    text
  end

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
    body.html_safe
  end

end
