class Entry < ActiveRecord::Base
  has_one :entry_type

  def body_without_fragment_links
    body.gsub(/<lfrag [^>]+>/, "").gsub("</lfrag>", "").
         gsub(/<bfrag [^>]+>/, "").gsub("</bfrag>", "")
  end

  def line_fragments
    fragments("lfrag")
  end

  def body_fragments
    fragments("bfrag")
  end

  private

  def fragments(fragment_type)
    frags = []
    Entry.find(:all, :conditions => "body like '%#{self.title}%'").each do |entry|
      entry.body =~ /<#{fragment_type} [^>]+#{self.title}[^>]*>(.*)<\/#{fragment_type}>/
      fragment = $1.sub(/<\/#{fragment_type}>.*/, "").strip
      frags << {:source => entry, :fragment => fragment}
    end
    frags
  end
  
end
