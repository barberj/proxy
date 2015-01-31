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
    path = flattens? ? flat_path : self.dpath
    value = Dpaths.dselect(h, path)
    if value && collection_path?
      value.first
    else
      value
    end
  end

  def value_to_api(h, user_value)
    value = flattens? ? [user_value] : user_value
    Dpaths.dput(h, self.field.dpath, value)
  end

  def value_to_user(h, api_value)
    values = flattens? ? api_value[field_index] : api_value
    path = flattens? ? flat_path : self.dpath
    values = [values] if !collection_path?

    values.each do |value|
      Dpaths.dput(h, path, value)
    end
  end

  def flat_path
    self.dpath.gsub(%r(/[0-9]+/), '/')
  end

  def collection_path?
    self.dpath.match(%r(//.*\*))
  end

  def field_index
    @field_index ||= Integer(self.dpath.match(%r(/([0-9]+)/))[1]) rescue nil
  end

  def flattens?
    field_index.present?
  end

  def as_json(*args)
    Jbuilder.new do |json|
      json.(self,
        :id,
        :name,
        :dpath,
        :is_active,
        :field_id,
        :encoded_resource_id
      )
      json.field_name field.name
    end.attributes!
  end

  def as_template
    Jbuilder.new do |json|
      json.(self,
        :dpath,
        :is_active,
        :field_id,
      )
    end.attributes!
  end
end
