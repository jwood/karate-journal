class EntriesController < ApplicationController

  before_filter :load_entry, only: [:show, :edit, :update, :destroy]

  def index
    @kihon_entries            = Entry.by_type(EntryType.KIHON).ordered_by_title
    @kata_entries             = Entry.by_type(EntryType.KATA).ordered_by_title
    @kumite_entries           = Entry.by_type(EntryType.KUMITE).ordered_by_title
    @drill_entries            = Entry.by_type(EntryType.DRILL).ordered_by_title
    @other_entries            = Entry.by_type(EntryType.OTHER).ordered_by_title
    @senior_visit_entries     = Entry.by_type(EntryType.SENIOR_VISIT).ordered_by_date
    @special_training_entries = Entry.by_type(EntryType.SPECIAL_TRAINING).ordered_by_date
    @experience_entries       = Entry.by_type(EntryType.EXPERIENCE).ordered_by_date
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
    @search_terms = @query.split(' ')
    @results = Entry.search(@search_terms)
  end

  private

  def load_entry
    @entry = Entry.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:title, :body, :source, :entry_type_id)
  end

end
