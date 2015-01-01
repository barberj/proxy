class Encoding < ActiveRecord::Base
  belongs_to :installed_api, inverse_of: :encodings
  has_many :encoded_resources, inverse_of: :encoding, dependent: :destory
  has_many :encoded_fields, inverse_of: :encoding, dependent: :destroy
end
