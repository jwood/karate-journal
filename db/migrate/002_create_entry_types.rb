class CreateEntryTypes < ActiveRecord::Migration
  def self.up
    create_table :entry_types do |t|
      t.column :description, :string
    end

    EntryType.create(:description => "Kihon")
    EntryType.create(:description => "Kata")
    EntryType.create(:description => "Kumite")
    EntryType.create(:description => "Drill")
    EntryType.create(:description => "Other")

    add_column :entries, :entry_type_id, :integer
  end

  def self.down
    drop_table :entry_types
    remove_column :entries, :entry_type_id
  end
end
