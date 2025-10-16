class CreateAiModels < ActiveRecord::Migration[8.0]
  def change
    create_table :ai_models do |t|
      t.references :ai_integration, null: false, foreign_key: { to_table: :integrations }
      t.string :provider, null: false
      t.string :name, null: false
      t.string :category, null: false
      t.text :description, null: false
      t.jsonb :config, null: false, default: {}
    end
  end
end
