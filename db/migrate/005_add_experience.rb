class AddExperience < ActiveRecord::Migration
  def self.up
    EntryType.create(:description => "Experience")
  end

  def self.down
    EntryType.delete(:description => "Experience")
  end
end
