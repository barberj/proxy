class Account < ActiveRecord::Base
  has_many :users, inverse_of: :account
  has_many :apis, inverse_of: :account
  has_many :installed_apis, inverse_of: :account
  has_many :data_encodings, inverse_of: :account

  def internal?
    self.id == 1
  end
end
