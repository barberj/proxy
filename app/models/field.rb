class Field < ActiveRecord::Base
  belongs_to :resource, inverse_of: :fields
  has_many :encoded_fields, inverse_of: :field
end
