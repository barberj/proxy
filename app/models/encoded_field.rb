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
    if value && value.kind_of?(Array) && !self.field.collection?
      value.first
    else
      value
    end
  end

  def value_to_api(h, value)
    Dpaths.dput(h, self.field.dpath, value)
  end

  def value_to_user(h, api_value)
    value, path = if flattens?
      [api_value[field_index], flat_path]
    else
      [api_value, self.dpath]
    end

    value = Array.wrap(value) if collection?
    values = !is_nested_in_a_collection? ? [value] : value

    #binding.pry if values == [['730 Peachtree St NE #330']]
    values.each do |value|
      Dpaths.dput(h, path, value)
    end
  end

  def flat_path
    self.dpath.gsub(%r(/[0-9]+/), '/')
  end

  def value_should_be_individual?
    (
      is_nested_in_a_collection?  || !self.field.is_nested_in_a_collection?
    ) && (
      !self.field.collection?
    )
  end

  def field_index
    @field_index ||= Integer(self.dpath.match(%r(/([0-9]+)/))[1]) rescue nil
  end

  def flattens?
    field_index.present? && !self.field.is_nested_in_a_collection?
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
