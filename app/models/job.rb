class Job < ActiveRecord::Base
  include HttpRequest
  belongs_to :data_encoding, inverse_of: :jobs
  has_one :installed_api, through: :data_encoding
  has_one :api, through: :data_encoding

  def process
    raise NotImplementedError
  end
end
