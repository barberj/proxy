class InstalledApi < ActiveRecord::Base
  include ResourceRequests

  belongs_to :account, inverse_of: :installed_apis
  belongs_to :api, inverse_of: :installed_apis
  has_many :data_encodings, inverse_of: :installed_api, dependent: :destroy

  before_create :generate_tokens, :default_name
  after_create :create_default_data_encoding

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

  def create_default_data_encoding
    self.data_encodings.create(
      name: "#{self.name} Encoding",
      account_id: self.account_id,
      is_default: true
    )
  end
end
