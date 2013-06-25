class EntryType < ActiveRecord::Base

  private

  def self.method_missing(method, *args)
    self.entry_types[method.to_s] || super
  end

  def self.entry_types
    @entry_types ||= Hash[*EntryType.all.map { |x| [x.description.upcase, x] }.flatten]
  end

end
