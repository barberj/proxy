class AddImageToApi < ActiveRecord::Migration
  def change
    add_column :apis, :image, :text
  end
end
