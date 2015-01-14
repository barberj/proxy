class Account < ActiveRecord::Base
  has_many :users, inverse_of: :account
  has_many :apis, inverse_of: :account
  has_many :data_encodings, inverse_of: :account
  has_many :jobs, inverse_of: :account

  def internal?
    self.id == 1
  end

  def install_api(api)
    self.data_encodings.create(
      name: "#{api.name} Encoding",
      api_id: api.id,
      encoded_resources_attributes: api.resources.map(&:to_eh)
    )
  end
end
