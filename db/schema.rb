# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_10_23_142746) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vector"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ai_models", force: :cascade do |t|
    t.bigint "ai_integration_id", null: false
    t.string "category", null: false
    t.jsonb "config", default: {}, null: false
    t.text "description", null: false
    t.string "name", null: false
    t.string "provider", null: false
    t.index ["ai_integration_id"], name: "index_ai_models_on_ai_integration_id"
  end

  create_table "collections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "documents_count", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "title"], name: "index_collections_on_user_id_and_title", unique: true
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "document_chunks", force: :cascade do |t|
    t.integer "character_count", default: 0
    t.integer "chunk_index", null: false
    t.text "content", null: false
    t.text "content_summary"
    t.datetime "created_at", null: false
    t.bigint "document_id", null: false
    t.vector "embedding", limit: 1536
    t.jsonb "metadata", default: {}
    t.datetime "updated_at", null: false
    t.index ["document_id", "chunk_index"], name: "index_document_chunks_on_document_id_and_chunk_index", unique: true
    t.index ["document_id"], name: "index_document_chunks_on_document_id"
    t.index ["embedding"], name: "index_document_chunks_on_embedding", opclass: :vector_cosine_ops, using: :ivfflat
    t.index ["metadata"], name: "index_document_chunks_on_metadata", using: :gin
  end

  create_table "documents", force: :cascade do |t|
    t.boolean "ai_extract", default: false, null: false
    t.text "ai_summary"
    t.integer "chunk_count", default: 0, null: false
    t.bigint "collection_id", null: false
    t.string "content_hash"
    t.datetime "created_at", null: false
    t.string "description"
    t.integer "document_type", default: 0, null: false
    t.jsonb "extracted_metadata", default: {}
    t.integer "page_count", default: 0, null: false
    t.datetime "processed_at"
    t.integer "processing_status", default: 0, null: false
    t.bigint "size_bytes", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["ai_extract"], name: "index_documents_on_ai_extract"
    t.index ["collection_id", "title"], name: "index_documents_on_collection_id_and_title", unique: true
    t.index ["collection_id"], name: "index_documents_on_collection_id"
    t.index ["content_hash"], name: "index_documents_on_content_hash"
    t.index ["document_type"], name: "index_documents_on_document_type"
    t.index ["extracted_metadata"], name: "index_documents_on_extracted_metadata", using: :gin
    t.index ["processing_status"], name: "index_documents_on_processing_status"
  end

  create_table "integrations", force: :cascade do |t|
    t.jsonb "config", default: {}, null: false
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.string "name", null: false
    t.string "provider", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["name"], name: "index_integrations_on_name", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.string "ip_address"
    t.string "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["expires_at"], name: "index_sessions_on_expires_at", unique: true
    t.index ["remember_token"], name: "index_sessions_on_remember_token", unique: true
    t.index ["remember_token_expires_at"], name: "index_sessions_on_remember_token_expires_at", unique: true
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "user_integrations", force: :cascade do |t|
    t.string "access_token"
    t.bigint "active_chat_id"
    t.bigint "active_embedding_id"
    t.jsonb "config", default: {}, null: false
    t.datetime "connected_at"
    t.datetime "created_at", null: false
    t.bigint "integration_id", null: false
    t.string "refresh_token"
    t.datetime "token_expires_at"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "username"
    t.index ["active_chat_id"], name: "index_user_integrations_on_active_chat_id"
    t.index ["active_embedding_id"], name: "index_user_integrations_on_active_embedding_id"
    t.index ["integration_id"], name: "index_user_integrations_on_integration_id"
    t.index ["user_id", "integration_id"], name: "index_user_integrations_on_user_id_and_integration_id", unique: true
    t.index ["user_id"], name: "index_user_integrations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "collections_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ai_models", "integrations", column: "ai_integration_id"
  add_foreign_key "collections", "users"
  add_foreign_key "document_chunks", "documents"
  add_foreign_key "documents", "collections"
  add_foreign_key "sessions", "users"
  add_foreign_key "user_integrations", "ai_models", column: "active_chat_id"
  add_foreign_key "user_integrations", "ai_models", column: "active_embedding_id"
  add_foreign_key "user_integrations", "integrations"
  add_foreign_key "user_integrations", "users"
end
