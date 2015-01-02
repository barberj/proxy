class EncodedResource < ActiveRecord::Base
  belongs_to :resource
  belongs_to :data_encoding, inverse_of: :encoded_resources
  has_many :encoded_fields, inverse_of: :encoded_resource

  validates :name, presence: true,
                   uniqueness: { scope: :data_encoding_id }

  accepts_nested_attributes_for :encoded_fields
end
