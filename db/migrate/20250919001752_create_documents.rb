class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.string :title, null: false
      t.string :description
      t.bigint :size_bytes, default: 0, null: false
      t.integer :document_type, default: 0, null: false
      t.references :collection, null: false, foreign_key: true
      t.timestamps
    end

    add_index :documents, [:collection_id, :title], unique: true
    add_index :documents, :document_type
  end
end
