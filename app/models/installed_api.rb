class InstalledApi < ActiveRecord::Base
  include ResourceRequests

  belongs_to :account, inverse_of: :installed_apis
  belongs_to :api, inverse_of: :installed_apis

  before_create :generate_tokens, :default_name

private

  def generate_tokens
    begin
      self.local_token = SecureRandom.hex
    end while self.class.exists?(:local_token => self.local_token)
    begin
      self.remote_token = SecureRandom.hex
    end while self.class.exists?(:remote_token => self.remote_token)
  end

  def default_name
    self.name ||= "My #{api.name}"
  end
end
