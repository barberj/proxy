class User < ActiveRecord::Base
  has_secure_password
  belongs_to :account, inverse_of: :users

  def internal?
    self.account_id == 1
  end
end
