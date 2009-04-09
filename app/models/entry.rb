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

  # This is without a doubt the worst performing implementation of this method.
  # But it works, and it works well with my small database.  Saving any sort
  # of optimizations for a later date.
  def fragments(fragment_type)
    frags = []
    Entry.find(:all, :conditions => "body like '%#{self.title}%'").each do |entry|
      if entry.body.gsub("\r\n", "[newline]") =~ /<#{fragment_type} [^>]+#{self.title}[^>]*>(.*)<\/#{fragment_type}>/
        fragment = $1.sub(/<\/#{fragment_type}>.*/, "").strip
        fragment.gsub!("[newline]", "\r\n")
        frags << {:source => entry, :fragment => fragment}
      end
    end
    frags
  end
  
end
