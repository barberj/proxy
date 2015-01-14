class Api < ActiveRecord::Base
  belongs_to :account, inverse_of: :apis
  has_many :resources, inverse_of: :api
  has_many :data_encodings, inverse_of: :api

  accepts_nested_attributes_for :resources

  after_create :install_dev_api

  def as_json(*args)
    Jbuilder.new do |json|
      json.(self,
        :id,
        :name,
        :install_url,
        :uninstall_url,
        :is_active
      )
    end.attributes!
  end

private

  def install_dev_api
    api = account.install_api(self)
    api.name = "Development #{self.name} Encoding"
    api.is_dev = true
    api.save
  end
end
