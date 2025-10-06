class DocumentChunk < ApplicationRecord
  has_neighbors :embedding

  belongs_to :document
  has_one :collection, through: :document
  has_one :user, through: :collection

  validates :content, presence: true
  validates :chunk_index, presence: true, uniqueness: { scope: :document_id }

  scope :with_embeddings, -> { where.not(embedding: nil) }

  # --- Search within a specific collection ---
  def self.similarity_search_in_collection(query, collection:, limit: 10)
    embedding = Document::Embedding.new.generate_embedding(query)

    nearest_neighbors(:embedding, embedding, distance: 'cosine')
      .where(document: collection.documents)
      .limit(limit)
      .includes(document: :collection)
  end

  # --- Search within a specific document ---
  def self.similarity_search_in_document(query, document:, limit: 10)
    embedding = Document::Embedding.new.generate_embedding(query)

    nearest_neighbors(:embedding, embedding, distance: 'cosine')
      .where(document_id: document.id)
      .limit(limit)
      .includes(document: :collection)
  end

  # --- Search across all documents/collections of a specific user ---
  def self.similarity_search_for_user(query, user:, limit: 10)
    embedding = Document::Embedding.new.generate_embedding(query)

    nearest_neighbors(:embedding, embedding, distance: 'cosine')
      .joins(document: :collection)
      .where(collections: { user_id: user.id })
      .limit(limit)
      .includes(document: :collection)
  end
end
