class AddAiExtractToDocuments < ActiveRecord::Migration[8.0]
  def change
    add_column :documents, :ai_extract, :boolean, default: false, null: false
    add_index :documents, :ai_extract
  end
end
