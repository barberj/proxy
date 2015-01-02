class DataEncoding < ActiveRecord::Base
  include Token

  belongs_to :installed_api, inverse_of: :data_encodings
  belongs_to :account, inverse_of: :data_encodings
  has_many :encoded_resources, inverse_of: :data_encoding, dependent: :destroy
  has_many :jobs, inverse_of: :data_encoding, dependent: :destroy
  has_one :api, through: :installed_api

  accepts_nested_attributes_for :encoded_resources

  def can_process?(resource, process_type)
    if encoded_resource = self.encoded_resources.find_by(name: resource)
      encoded_resource.resource.send(:"#{process_type}_url").present?
    end
  end

  def can_process_updated?(resource)
    can_process?(resource, :updated)
  end

  def can_process_created?(resource)
    can_process?(resource, :created)
  end

  def can_process_read?(resource)
    can_process?(resource, :read)
  end

  def can_process_search?(resource)
    can_process?(resource, :search)
  end
end
