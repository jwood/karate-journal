class EntriesController < ApplicationController

  before_filter :load_entry, only: [:show, :edit, :update, :destroy]

  def index
    @kihon_entries            = Entry.by_type(EntryType.KIHON)
    @kata_entries             = Entry.by_type(EntryType.KATA)
    @kumite_entries           = Entry.by_type(EntryType.KUMITE)
    @drill_entries            = Entry.by_type(EntryType.DRILL)
    @other_entries            = Entry.by_type(EntryType.OTHER)
    @senior_visit_entries     = Entry.by_type(EntryType.SENIOR_VISIT)
    @special_training_entries = Entry.by_type(EntryType.SPECIAL_TRAINING)
    @experience_entries       = Entry.by_type(EntryType.EXPERIENCE)
  end

  def show
  end

  def new
    @entry = Entry.new
  end

  def create
    @entry = Entry.new(entry_params)
    if @entry.save
      redirect_to entry_path(@entry)
    else
      logger.error "Create entry failed: #{@entry.errors.full_messages}"
      render action: 'new'
    end
  end

  def edit
  end

  def update
    @entry.attributes = entry_params
    if @entry.save
      redirect_to entry_path(@entry)
    else
      logger.error "Edit entry failed: #{@entry.errors.full_messages}"
      render action: 'edit'
    end
  end

  def destroy
    @entry.destroy
    redirect_to root_path
  end

  def search
    @query = params[:query]
    result_hash = {}
    @search_terms = @query.split(' ')

    @search_terms.each do |term|
      # Search for query in source
      entries = Entry.where('source like ?', "%#{term}%")
      result_hash = add_entries_to_search_results(result_hash, entries, 'source', term, 100)

      # Search for query in title
      entries = Entry.where('title like ?', "%#{term}%")
      result_hash = add_entries_to_search_results(result_hash, entries, 'title', term, 75)

      # Search for query in body
      entries = Entry.where('body like ?', "%#{term}%")
      result_hash = add_entries_to_search_results(result_hash, entries, 'body', term, 5)
    end

    @results = result_hash.sort { |a,b| b[1] <=> a[1] }.map { |x| x[0] }
  end

  private

  def load_entry
    @entry = Entry.find(params[:id])
  end

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

  def entry_params
    params.require(:entry).permit(:title, :body, :source, :entry_type_id)
  end
end
