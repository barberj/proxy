class Field < ActiveRecord::Base
  belongs_to :resource, inverse_of: :fields
end
