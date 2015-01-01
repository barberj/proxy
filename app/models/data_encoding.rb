class DataEncoding < ActiveRecord::Base
  belongs_to :installed_api, inverse_of: :data_encodings
  belongs_to :account, inverse_of: :data_encodings
  has_many :encoded_resources, inverse_of: :data_encoding, dependent: :destroy
  has_many :encoded_fields, inverse_of: :data_encoding, dependent: :destroy

  accepts_nested_attributes_for :encoded_resources
end
