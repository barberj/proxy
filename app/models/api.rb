class Api < ActiveRecord::Base
  belongs_to :account, inverse_of: :apis
  has_many :resources, inverse_of: :api
  has_many :installed_apis, inverse_of: :api

   accepts_nested_attributes_for :resources
end
