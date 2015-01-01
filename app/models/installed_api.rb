class InstalledApi < ActiveRecord::Base
  include ResourceRequests
  include Token

  belongs_to :account, inverse_of: :installed_apis
  belongs_to :api, inverse_of: :installed_apis
  has_many :data_encodings, inverse_of: :installed_api, dependent: :destroy

  before_create :default_name
  after_create :create_default_data_encoding

private

  def default_name
    self.name ||= "My #{api.name}"
  end

  def create_default_data_encoding
    self.data_encodings.create(
      name: "#{self.name} Encoding",
      account_id: self.account_id,
      is_default: true,
      encoded_resources_attributes: self.api.resources.map(&:to_eh)
    )
  end
end
