class EncodedResource < ActiveRecord::Base
  belongs_to :encoding, inverse_of: :encoded_resources
  has_many :encoded_fields, inverse_of: :encoded_resource
end
