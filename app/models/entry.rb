class Entry < ActiveRecord::Base
  extend EntrySearch

  has_one :entry_type

  scope :by_type, ->(entry_type) { where(entry_type_id: entry_type) }
  scope :ordered_by_title, -> { order('title') }
  scope :ordered_by_date, -> { order('created_at') }

  validates :title, presence: true
  validates :body, presence: true

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
    fragment_regex = fragment_regex(fragment_type)

    Entry.where("body like ?", "%#{self.title}%").each do |entry|
      text = entry.body.gsub("\r\n", "[newline]")
      while text =~ fragment_regex
        fragment = $1.strip.gsub("[newline]", "\r\n")
        frags << { source: entry, fragment: fragment }
        text = text.sub(fragment_regex, "")
      end
    end

    frags.sort { |a,b| b[:source].created_at <=> a[:source].created_at }
  end

  def fragment_regex(fragment_type)
    /<#{fragment_type} [^>]+#{self.title}[^>]*>([^<]+)<\/#{fragment_type}>/
  end

end
