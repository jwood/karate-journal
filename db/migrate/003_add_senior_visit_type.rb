class AddSeniorVisitType < ActiveRecord::Migration
  def self.up
    EntryType.create(:description => "Senior Visit")
  end

  def self.down
    EntryType.delete(:description => "Senior Visit")
  end
end
