class CreateDocumentChunks < ActiveRecord::Migration[8.0]
  def change
    create_table :document_chunks do |t|
      t.references :document, null: false, foreign_key: true, index: true
      t.text :content, null: false
      t.text :content_summary # AI-generated summary of this chunk
      t.integer :chunk_index, null: false
      t.integer :character_count, default: 0
      t.vector :embedding, limit: 1536 # OpenAI embeddings are 1536 dimensions
      t.jsonb :metadata, default: {}
      t.timestamps

      t.index [:document_id, :chunk_index], unique: true
      t.index :embedding, using: :ivfflat, opclass: :vector_cosine_ops
      t.index :metadata, using: :gin
    end
  end
end
