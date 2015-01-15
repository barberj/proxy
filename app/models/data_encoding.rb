class DataEncoding < ActiveRecord::Base
  include Token
  belongs_to :account, inverse_of: :data_encodings
  has_many :encoded_resources, inverse_of: :data_encoding, dependent: :destroy
  has_many :jobs, inverse_of: :data_encoding, dependent: :destroy
  belongs_to :api, inverse_of: :data_encodings

  accepts_nested_attributes_for :encoded_resources

  def encoded_resource_for(resource, process_type)
    if encoded_resource = self.encoded_resources.find_by(name: resource)
      if encoded_resource.resource.can_request?(process_type)
        encoded_resource
      end
    end
  end

  def as_json(*args)
    Jbuilder.new do |json|
      json.(self,
        :id,
        :name
      )
      json.encoded_resources_attributes self.encoded_resources.map(&:as_json)
      json.install_url "#{api.install_url}?token=#{token}"
    end.attributes!
  end
end
