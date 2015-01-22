class DataEncodingTemplate < ActiveRecord::Base
  belongs_to :account, inverse_of: :data_encoding_templates
  belongs_to :api, inverse_of: :data_encoding_templates
end
