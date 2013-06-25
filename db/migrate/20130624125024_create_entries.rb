class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.string :source

      t.timestamps
    end
  end
end
