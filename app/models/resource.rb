class Resource < ActiveRecord::Base
  belongs_to :api, inverse_of: :resources
  has_many :fields, inverse_of: :resource

   accepts_nested_attributes_for :fields
end
