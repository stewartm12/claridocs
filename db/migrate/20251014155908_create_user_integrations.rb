class CreateUserIntegrations < ActiveRecord::Migration[8.0]
  def change
    create_table :user_integrations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :integration, null: false, foreign_key: true
      t.references :active_chat, null: true, foreign_key: { to_table: :ai_models }
      t.references :active_embedding, null: true, foreign_key: { to_table: :ai_models }
      t.string :access_token
      t.string :refresh_token
      t.datetime :token_expires_at
      t.datetime :connected_at
      t.string :username
      t.jsonb :config, null: false, default: {}
      t.timestamps
    end

    add_index :user_integrations, [:user_id, :integration_id], unique: true
  end
end
