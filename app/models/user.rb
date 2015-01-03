class User < ActiveRecord::Base
  include Token

  belongs_to :account, inverse_of: :users

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, length: { minimum: 6 }

  has_secure_password

  before_save { self.email = email.downcase }

  def internal?
    self.account_id == 1
  end
end
