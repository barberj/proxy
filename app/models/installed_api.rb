class InstalledApi < ActiveRecord::Base
  belongs_to :account, inverse_of: :installed_apis
  belongs_to :api, inverse_of: :installed_apis

  before_create :generate_token, :default_name

private

  def generate_token
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(:token => token)
  end

  def default_name
    self.name ||= "My #{api.name}"
  end
end
