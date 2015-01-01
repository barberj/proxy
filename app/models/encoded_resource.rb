class EncodedResource < ActiveRecord::Base
  belongs_to :data_encoding, inverse_of: :encoded_resources
  belongs_to :resource
  has_many :encoded_fields, inverse_of: :encoded_resource

  accepts_nested_attributes_for :encoded_fields
end
