class Account < ActiveRecord::Base
  has_many :users, inverse_of: :account

  def internal?
    self.id == 1
  end
end
