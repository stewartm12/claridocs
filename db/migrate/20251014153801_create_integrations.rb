class CreateIntegrations < ActiveRecord::Migration[8.0]
  def change
    create_table :integrations do |t|
      t.string :name, null: false
      t.string :provider, null: false
      t.string :url
      t.text :description, null: false
      t.jsonb :config, null: false, default: {}
      t.string :type, null: false
      t.index :name, unique: true
      t.timestamps
    end
  end
end
