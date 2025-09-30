class DocumentChunk < ApplicationRecord
  belongs_to :document

  validates :content, presence: true
  validates :chunk_index, presence: true, uniqueness: { scope: :document_id }

  scope :with_embeddings, -> { where.not(embedding: nil) }

  has_neighbors :embedding

  def similarity_search(query, limit: 10)
    embedding = Document::Embedding.new.generate_embedding(query)

    self.class
      .nearest_neighbors(:embedding, embedding, distance: 'cosine')
      .where(document: document.collection.documents.processed)
      .limit(limit)
      .includes(document: :collection)
  end
end
