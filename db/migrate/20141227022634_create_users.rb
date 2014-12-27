class CreateUsers < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.timestamps null: false
    end

    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.datetime :last_login_at
      t.integer :account_id, null: false

      t.timestamps null: false
    end
  end
end
