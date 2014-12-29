class Api < ActiveRecord::Base
  belongs_to :account, inverse_of: :apis
  has_many :resources, inverse_of: :api
  has_many :installed_apis, inverse_of: :api

   accepts_nested_attributes_for :resources

  after_create :install_dev_api

private

  def install_dev_api
    account.installed_apis.create(
      name: "Development #{self.name}",
      api_id: self.id,
      is_dev: true
    )
  end
end
