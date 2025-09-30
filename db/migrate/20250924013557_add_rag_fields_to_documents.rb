class AddRagFieldsToDocuments < ActiveRecord::Migration[8.0]
  def change
    add_column :documents, :processing_status, :integer, default: 0, null: false
    add_column :documents, :content_hash, :string # For detecting content changes
    add_column :documents, :processed_at, :datetime
    add_column :documents, :chunk_count, :integer, default: 0, null: false
    add_column :documents, :ai_summary, :text
    add_column :documents, :extracted_metadata, :jsonb, default: {}
    
    add_index :documents, :processing_status
    add_index :documents, :content_hash
    add_index :documents, :extracted_metadata, using: :gin
  end
end
