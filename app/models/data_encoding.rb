class DataEncoding < ActiveRecord::Base
  include Token

  belongs_to :installed_api, inverse_of: :data_encodings
  belongs_to :account, inverse_of: :data_encodings
  has_many :encoded_resources, inverse_of: :data_encoding, dependent: :destroy

  accepts_nested_attributes_for :encoded_resources
end
