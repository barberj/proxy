class DataEncoding < ActiveRecord::Base
  include Token

  belongs_to :installed_api, inverse_of: :data_encodings
  belongs_to :account, inverse_of: :data_encodings
  has_many :encoded_resources, inverse_of: :data_encoding, dependent: :destroy
  has_many :jobs, inverse_of: :data_encoding, dependent: :destroy
  has_one :api, through: :installed_api

  accepts_nested_attributes_for :encoded_resources

  def resource_to_process(resource)
    if encoded_resource = self.encoded_resources.find_by(name: resource)
      encoded_resource.resource
    end
  end

  def can_process?(resource, process_type)
    if resource = resource_to_process(resource)
      resource.can_request?(process_type)
    end
  end
end
