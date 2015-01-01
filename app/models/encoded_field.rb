class EncodedField < ActiveRecord::Base
  belongs_to :encoding, inverse_of: :encoded_fields
  belongs_to :encoded_resource, inverse_of: :encoded_fields
  belongs_to :field, inverse_of: :encoded_fields
end
