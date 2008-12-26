class AddSpecialTrainingType < ActiveRecord::Migration
  def self.up
    EntryType.create(:description => "Special Training")
  end

  def self.down
    EntryType.delete(:description => "Special Training")
  end
end
