class EncodedResource < ActiveRecord::Base
  belongs_to :resource
  belongs_to :data_encoding, inverse_of: :encoded_resources
  has_many :encoded_fields, inverse_of: :encoded_resource, dependent: :destroy

  validates :name, presence: true,
                   uniqueness: { scope: :data_encoding_id }

  accepts_nested_attributes_for :encoded_fields

  def as_json(*args)
    Jbuilder.new do |json|
      json.(self,
        :id,
        :name,
        :data_encoding_id,
        :resource_id
      )
      json.resource_name resource.name

      json.encoded_fields_attributes self.encoded_fields.map(&:as_json)
    end.attributes!
  end

  def as_template
    Jbuilder.new do |json|
      json.(self,
        :name,
        :resource_id
      )
      json.encoded_fields_attributes self.encoded_fields.map(&:as_template)
    end.attributes!
  end
end
