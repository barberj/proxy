class RelaxUserRequirements < ActiveRecord::Migration
  def change
    change_column :users, :first_name, :string, null: true
    change_column :users, :last_name, :string, null: true
  end
end
