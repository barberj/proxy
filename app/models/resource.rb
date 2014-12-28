class Resource < ActiveRecord::Base
  belongs_to :api, inverse_of: :resources
end
