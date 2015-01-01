class EncodedResource < ActiveRecord::Base
  belongs_to :encoding, inverse_of: :encoded_resources
  has_many :encoded_fields, inverse_of: :encoded_resource

  accepts_nested_attributes_for :encoded_fields
end
