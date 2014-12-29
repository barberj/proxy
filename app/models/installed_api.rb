class InstalledApi < ActiveRecord::Base
  belongs_to :account, inverse_of: :installed_apis
  belongs_to :api, inverse_of: :installed_apis
end
