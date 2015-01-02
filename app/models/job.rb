class Job < ActiveRecord::Base
  belongs_to :data_encoding, inverse_of: :jobs

  def process
    raise NotImplementedError
  end
end
