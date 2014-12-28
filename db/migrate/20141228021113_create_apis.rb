class CreateApis < ActiveRecord::Migration
  def change
    create_table :apis do |t|
      t.string :name
      t.string :install_url, null: false
      t.string :uninstall_url, null: false
      t.boolean :is_active
      t.integer :account_id

      t.timestamps null: false
    end

    create_table :resources do |t|
      t.integer :api_id, null: false
      t.string :name, null: false
      t.string :search_url
      t.string :created_url
      t.string :updated_url
      t.string :read_url
      t.string :create_url
      t.string :update_url
      t.string :delete_url

      t.timestamps null: false
    end
  end
end
