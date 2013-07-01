module EntrySearch

  def search(search_terms)
    result_hash = {}

    search_terms.each do |term|
      # Search for term in source
      entries = Entry.where('source like ?', "%#{term}%")
      result_hash = add_entries_to_search_results(result_hash, entries, 'source', term, 100)

      # Search for term in title
      entries = Entry.where('title like ?', "%#{term}%")
      result_hash = add_entries_to_search_results(result_hash, entries, 'title', term, 75)

      # Search for term in body
      entries = Entry.where('body like ?', "%#{term}%")
      result_hash = add_entries_to_search_results(result_hash, entries, 'body', term, 5)
    end

    result_hash.sort { |a,b| b[1] <=> a[1] }.map { |x| x[0] }
  end

  private

  def add_entries_to_search_results(results, entries, field, term, points)
    entries.each do |entry|
      if results[entry].nil?
        results[entry] = points * count_occurrences(term, entry[field])
      else
        results[entry] = results[entry] + (points * count_occurrences(term, entry[field]))
      end
    end
    results
  end

  def count_occurrences(word, paragraph)
    count = 0
    paragraph.split(" ") do |pword|
      count = count + 1 if pword.upcase.tr('. ', '') == word.upcase
    end
    count
  end

end
