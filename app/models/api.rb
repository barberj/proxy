class Api < ActiveRecord::Base
  belongs_to :account, inverse_of: :apis
end
