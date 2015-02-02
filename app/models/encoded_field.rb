class EncodedField < ActiveRecord::Base
  include FieldDpath
  belongs_to :field
  belongs_to :encoded_resource, inverse_of: :encoded_fields

  validates :dpath, presence: true,
                    uniqueness: { scope: :encoded_resource_id }

  def value_from_api(h)
    value = Dpaths.dselect(h, self.field.dpath)
    value = if !collection? && !is_nested_in_a_collection?
      Array.wrap(value).first
    else
      value
    end

    Array.wrap(value)
  end

  def value_from_user(h)
    value = Dpaths.dselect(h, self.dpath)
    value = if !self.field.collection? && !self.field.is_nested_in_a_collection?
      Array.wrap(value).first
    else
      value
    end

    Array.wrap(value)
  end

  def value_to_api(h, values)
    Array.wrap(values).each_with_index do |value, index|
      next unless value
      Dpaths.dput(h, self.field.dpath_for(index), value)
    end
  end

  def value_to_user(h, values)
    Array.wrap(values).each_with_index do |value, index|
      next unless value
      Dpaths.dput(h, self.dpath_for(index), value)
    end
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
