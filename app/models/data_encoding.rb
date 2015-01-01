class DataEncoding < ActiveRecord::Base
  include Token

  belongs_to :installed_api, inverse_of: :data_encodings
  belongs_to :account, inverse_of: :data_encodings
  has_many :encoded_resources, inverse_of: :data_encoding, dependent: :destroy

  accepts_nested_attributes_for :encoded_resources

  def can_request?(resource, request_type)
    if encoded_resource = self.encoded_resources.find_by(name: resource)
      encoded_resource.resource.send(:"#{request_type}_url").present?
    end
  end

  def can_request_updated?(resource)
    can_request?(resource, :updated)
  end

  def can_request_created?(resource)
    can_request?(resource, :created)
  end

  def can_request_identifiers?(resource)
    can_request?(resource, :read)
  end

  def can_request_search?(resource)
    can_request?(resource, :search)
  end
end
