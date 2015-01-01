class Field < ActiveRecord::Base
  belongs_to :resource, inverse_of: :fields

  def to_h
    {
      id: self.id,
      name: self.name
    }
  end

  def to_eh
    {
      field_id: self.id,
      name: self.name
    }
  end
end
