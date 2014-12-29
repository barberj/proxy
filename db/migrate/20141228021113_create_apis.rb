class CreateApis < ActiveRecord::Migration
  def change
    create_table :apis do |t|
      t.string :name, null: false
      t.string :install_url, null: false
      t.string :uninstall_url, null: false
      t.boolean :is_active, default: false

      t.integer :account_id, null: false

      t.timestamps null: false
    end

    create_table :resources do |t|
      t.string :name, null: false
      t.string :customs_url
      t.string :search_url
      t.string :created_url
      t.string :updated_url
      t.string :read_url
      t.string :create_url
      t.string :update_url
      t.string :delete_url

      t.integer :api_id, null: false

      t.timestamps null: false
    end

    create_table :fields do |t|
      t.string :name, null: false
      t.string :type
      t.string :dpath, default: '/*'
      t.boolean :is_required, default: false
      t.boolean :used_for_search, default: false
      t.boolean :is_scope, default: false

      t.integer :resource_id, null: false

      t.timestamps null: false
    end

    create_table :installed_apis do |t|
      t.string :name, null: false
      t.string :token, null: false
      t.boolean :is_demo, default: false

      t.integer :api_id, null: false
      t.integer :account_id, null: false

      t.timestamps null: false
    end
  end
end
