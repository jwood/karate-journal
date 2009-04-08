class Entry < ActiveRecord::Base
  has_one :entry_type

  def body_without_fragment_links
    body.gsub(/<lfrag [^>]+>/, "").
         gsub("</lfrag>", "").
         gsub(/<bfrag [^>]+>/, "").
         gsub("</bfrag>", "")
  end

  def line_fragments
    frags = []
    Entry.find(:all, :conditions => "body like '%#{self.title}%'").each do |entry|
      entry.body =~ /<lfrag [^>]+#{self.title}[^>]*>(.*)<\/lfrag>/
      fragment = $1.sub(/<\/lfrag>.*/, "").strip
      frags << {:source => entry, :fragment => fragment}
    end
    frags
  end

  def body_fragments
    frags = []
    Entry.find(:all, :conditions => "body like '%#{self.title}%'").each do |entry|
      entry.body =~ /<bfrag [^>]+#{self.title}[^>]*>(.*)<\/bfrag>/
      fragment = $1.sub(/<\/bfrag>.*/, "").strip
      frags << {:source => entry, :fragment => fragment}
    end
    frags
  end
end
