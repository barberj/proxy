class Account < ActiveRecord::Base
  has_many :users, inverse_of: :account
end
