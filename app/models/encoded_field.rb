class EncodedField < ActiveRecord::Base
  include FieldDpath
  belongs_to :field
  belongs_to :encoded_resource, inverse_of: :encoded_fields

  validates :dpath, presence: true,
                    uniqueness: { scope: :encoded_resource_id }


  def value_from_api(h)
    Dpaths.dselect(h, self.field.dpath)
  end

  def value_from_user(h)
    Dpaths.dselect(h, self.dpath)
  end

  def value_to_api(h, value)
    Dpaths.dput(h, self.field.dpath, value)
  end

  def value_to_user(h, value)
    Dpaths.dput(h, self.dpath, value)
  end

  def as_json(*args)
    Jbuilder.new do |json|
      json.(self,
        :name,
        :dpath,
        :field_id,
        :encoded_resource_id
      )
    end.attributes!
  end
end
