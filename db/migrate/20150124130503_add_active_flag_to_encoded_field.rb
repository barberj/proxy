class AddActiveFlagToEncodedField < ActiveRecord::Migration
  def change
    change_table :encoded_fields do |t|
      t.boolean :is_active, default: true
    end
  end
end
