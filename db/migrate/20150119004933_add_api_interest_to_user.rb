class AddApiInterestToUser < ActiveRecord::Migration
  def change
    add_column :users, :interested_api, :string
    add_column :users, :billing_id, :integer
  end
end
