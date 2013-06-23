class MainController < ApplicationController

  def index
    @kihon_entries = find_entries_for_type('Kihon')
    @kata_entries = find_entries_for_type('Kata')
    @kumite_entries = find_entries_for_type('Kumite')
    @drill_entries = find_entries_for_type('Drill')
    @other_entries = find_entries_for_type('Other')
    @senior_visit_entries = find_entries_for_type('Senior Visit')
    @special_training_entries = find_entries_for_type('Special Training')
    @experience_entries = find_entries_for_type('Experience')
  end

  def edit_entry
    @entry = params[:id] && Entry.find_by_id(params[:id]) || Entry.new
    if request.post?
      @entry.attributes = params[:entry]
      if @entry.save
        redirect_to :action => 'show_entry', :id => @entry
      else
        logger.error("Edit entry failed: #{@entry.errors.full_messages}")
        render :action => 'edit_entry'
      end
    end
  end

  def show_entry
    @entry = Entry.find(params[:id])
  end

  def destroy_entry
    Entry.find(params[:id]).destroy
    redirect_to :action => 'index'
  end

  def search
    query = params[:query]
    result_hash = {}

    @search_terms = []
    query.split(' ').each { |word| @search_terms << word }

    @search_terms.each do |term|
      # Search for query in source
      entries = Entry.find(:all, :conditions => ['source like ?', '%' << term << '%'])
      result_hash = add_entries_to_search_results(result_hash, entries, 'source', term, 100)

      # Search for query in title
      entries = Entry.find(:all, :conditions => ['title like ?', '%' << term << '%'])
      result_hash = add_entries_to_search_results(result_hash, entries, 'title', term, 75)

      # Search for query in body
      entries = Entry.find(:all, :conditions => ['body like ?', '%' << term << '%'])
      result_hash = add_entries_to_search_results(result_hash, entries, 'body', term, 5)
    end

    result_array = result_hash.sort { |a, b| b[1] <=> a[1] }
    @results = result_array.collect { |x| x[0] }
  end

  private

  def count_occurrences(word, paragraph)
    count = 0
    paragraph.split(" ") do |pword|
      count = count + 1 if pword.upcase.tr('. ', '') == word.upcase
    end
    count
  end

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

  def find_entries_for_type(type)
    Entry.find_all_by_entry_type_id(EntryType.find_by_description(type), :order => 'title')
  end

end
