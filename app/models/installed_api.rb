class InstalledApi < ActiveRecord::Base
  belongs_to :account, inverse_of: :installed_apis
  belongs_to :api, inverse_of: :installed_apis

  before_create :generate_token

private

  def generate_token
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(:token => token)
  end
end
