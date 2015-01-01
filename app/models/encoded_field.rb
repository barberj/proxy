class EncodedField < ActiveRecord::Base
  belongs_to :field
  belongs_to :encoded_resource, inverse_of: :encoded_fields
end
