class CreateEntryTypes < ActiveRecord::Migration
  class EntryType < ActiveRecord::Base; end

  def change
    create_table :entry_types do |t|
      t.string :description, null: false
    end

    EntryType.create!(description: "Kihon")
    EntryType.create!(description: "Kata")
    EntryType.create!(description: "Kumite")
    EntryType.create!(description: "Drill")
    EntryType.create!(description: "Senior Visit")
    EntryType.create!(description: "Special Training")
    EntryType.create!(description: "Experience")
    EntryType.create!(description: "Other")

    add_column :entries, :entry_type_id, :integer
  end
end
