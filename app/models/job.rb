class Job < ActiveRecord::Base
  include HttpRequest
  include RedisCaching

  belongs_to :data_encoding, inverse_of: :jobs
  belongs_to :encoded_resource
  belongs_to :resource
  belongs_to :account
  has_one :installed_api, through: :data_encoding
  has_one :api, through: :data_encoding

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

  def data_url
    raise NotImplementedError
  end

private

  def process
    raise NotImplementedError
  end

  def encode_data
    encoded = []
    Array.wrap(self.results['results']).each do |data|
      encoded_datum = {}
      encoded_resource.encoded_fields.each do |encoded_field|
        if value = encoded_field.value_from_api(data)
          encoded_field.value_to_user(encoded_datum, value)
        end
      end
      encoded << encoded_datum if encoded_datum.present?
    end

    if encoded.present?
      self.results = self.results.merge(results: encoded)
    end

    self.status = 'processed'
    self.save
  end
end
