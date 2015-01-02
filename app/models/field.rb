class Field < ActiveRecord::Base
  belongs_to :resource, inverse_of: :fields

  validates :dpath, presence: true,
                    uniqueness: { scope: :resource_id }

  def name
    self.dpath.split('/').last
  end

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
