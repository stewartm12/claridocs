class CreateCollections < ActiveRecord::Migration[8.0]
  def change
    create_table :collections do |t|
      t.string :title, null: false
      t.text :description
      t.integer :documents_count, default: 0, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    add_index :collections, [:user_id, :title], unique: true
  end
end
