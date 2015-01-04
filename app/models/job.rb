class Job < ActiveRecord::Base
  include HttpRequest

  belongs_to :data_encoding, inverse_of: :jobs
  belongs_to :encoded_resource
  belongs_to :resource
  belongs_to :account
  has_one :installed_api, through: :data_encoding
  has_one :api, through: :data_encoding

  def process
    raise NotImplementedError
  end

  def to_builder
    Jbuilder.new do |json|
      json.id id
      json.status status
      json.params params
      json.resource resource.name
      json.api api.name
      json.data_encoding data_encoding.name

      (results||{}).each do |k, v|
        json.set! k, v
      end
    end
  end
end
