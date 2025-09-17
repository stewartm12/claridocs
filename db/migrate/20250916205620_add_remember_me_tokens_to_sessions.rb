class AddRememberMeTokensToSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :sessions, :remember_token, :string
    add_column :sessions, :remember_token_expires_at, :datetime
    add_column :sessions, :expires_at, :datetime
    
    add_index :sessions, :remember_token, unique: true
    add_index :sessions, :remember_token_expires_at, unique: true
    add_index :sessions, :expires_at, unique: true
  end
end
