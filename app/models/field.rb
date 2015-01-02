class Field < ActiveRecord::Base
  include FieldDpath

  belongs_to :resource, inverse_of: :fields

  validates :dpath, presence: true,
                    uniqueness: { scope: :resource_id }

  def to_h
    {
      id: self.id,
      dpath: self.dpath
    }
  end

  def to_eh
    {
      field_id: self.id,
      dpath: self.dpath
    }
  end
end
