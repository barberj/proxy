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

  def serializable_hash(*args)
    args.first.merge!(only: [
      :params, :status
    ])
    super.merge(self.results||{})
      .merge(
        'resource'         => resource.name,
        'encoded_resource' => encoded_resource.name,
        'api'              => api.name,
        'data_encoding'    => data_encoding.name
      )
  end
end
