class CreateRefinerycmsAuthenticationSchema < ActiveRecord::Migration
  def change
    create_table :refinery_user_plugins do |t|
      t.integer :user_id
      t.string  :name
      t.integer :position
    end

    add_index :refinery_user_plugins, :name
    add_index :refinery_user_plugins, [:user_id, :name], :unique => true
  end
end
