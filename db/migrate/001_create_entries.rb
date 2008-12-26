class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.column :title, :string
      t.column :body, :text
      t.column :source, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :entries
  end
end
