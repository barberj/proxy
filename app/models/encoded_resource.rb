class EncodedResource < ActiveRecord::Base
  belongs_to :resource
  belongs_to :data_encoding, inverse_of: :encoded_resources
  has_many :encoded_fields, inverse_of: :encoded_resource

  validates :name, presence: true,
                   uniqueness: { scope: :data_encoding_id }

  accepts_nested_attributes_for :encoded_fields

  def as_json(*args)
    Jbuilder.new do |json|
      json.(self,
        :name,
        :data_encoding_id,
        :resource_id
      )

      json.encoded_fields_attributes self.encoded_fields.as_json
    end.attributes!
  end
end
