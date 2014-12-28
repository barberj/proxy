class CreateApis < ActiveRecord::Migration
  def change
    create_table :apis do |t|
      t.string :name
      t.boolean :is_active
      t.integer :account_id

      t.timestamps null: false
    end
  end
end
