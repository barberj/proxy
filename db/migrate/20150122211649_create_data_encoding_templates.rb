class CreateDataEncodingTemplates < ActiveRecord::Migration
  def change
    create_table :data_encoding_templates do |t|
      t.integer :account_id, null: false
      t.integer :api_id, null: false

      t.json :encoded_attributes
    end
  end
end
