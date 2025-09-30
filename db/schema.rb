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

ActiveRecord::Schema[8.0].define(version: 2025_09_30_033204) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vector"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "collections", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "documents_count", default: 0, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "title"], name: "index_collections_on_user_id_and_title", unique: true
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "document_chunks", force: :cascade do |t|
    t.bigint "document_id", null: false
    t.text "content", null: false
    t.text "content_summary"
    t.integer "chunk_index", null: false
    t.integer "character_count", default: 0
    t.vector "embedding", limit: 1536
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id", "chunk_index"], name: "index_document_chunks_on_document_id_and_chunk_index", unique: true
    t.index ["document_id"], name: "index_document_chunks_on_document_id"
    t.index ["embedding"], name: "index_document_chunks_on_embedding", opclass: :vector_cosine_ops, using: :ivfflat
    t.index ["metadata"], name: "index_document_chunks_on_metadata", using: :gin
  end

  create_table "documents", force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.bigint "size_bytes", default: 0, null: false
    t.integer "document_type", default: 0, null: false
    t.bigint "collection_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "processing_status", default: 0, null: false
    t.string "content_hash"
    t.datetime "processed_at"
    t.integer "chunk_count", default: 0, null: false
    t.text "ai_summary"
    t.jsonb "extracted_metadata", default: {}
    t.boolean "ai_extract", default: false, null: false
    t.index ["ai_extract"], name: "index_documents_on_ai_extract"
    t.index ["collection_id", "title"], name: "index_documents_on_collection_id_and_title", unique: true
    t.index ["collection_id"], name: "index_documents_on_collection_id"
    t.index ["content_hash"], name: "index_documents_on_content_hash"
    t.index ["document_type"], name: "index_documents_on_document_type"
    t.index ["extracted_metadata"], name: "index_documents_on_extracted_metadata", using: :gin
    t.index ["processing_status"], name: "index_documents_on_processing_status"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "expires_at"
    t.index ["expires_at"], name: "index_sessions_on_expires_at", unique: true
    t.index ["remember_token"], name: "index_sessions_on_remember_token", unique: true
    t.index ["remember_token_expires_at"], name: "index_sessions_on_remember_token_expires_at", unique: true
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "collections_count", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "collections", "users"
  add_foreign_key "document_chunks", "documents"
  add_foreign_key "documents", "collections"
  add_foreign_key "sessions", "users"
end
