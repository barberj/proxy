class EncodedField < ActiveRecord::Base
  include FieldDpath
  belongs_to :field
  belongs_to :encoded_resource, inverse_of: :encoded_fields

  validates :dpath, presence: true,
                    uniqueness: { scope: :encoded_resource_id }


  def value_from_api(h)
    Dpaths.dselect(h, self.field.dpath)
  end

  def value_to_api(h)
    Dpaths.dselect(h, self.dpath)
  end
end