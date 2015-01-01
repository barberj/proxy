class Resource < ActiveRecord::Base
  belongs_to :api, inverse_of: :resources
  has_many :fields, inverse_of: :resource

  accepts_nested_attributes_for :fields

  def to_h
    {
      id: self.id,
      name: self.name,
      fields_attributes: self.fields.map(&:to_h)
    }
  end

  def to_eh
    {
      resource_id: self.id,
      name: self.name,
    #  encoded_fields_attributes: self.fields.map(&:to_eh)
    }
  end
end
