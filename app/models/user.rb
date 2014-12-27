class User < ActiveRecord::Base
  has_secure_password
  belongs_to :account, inverse_of: :users

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  def internal?
    self.account_id == 1
  end
end
