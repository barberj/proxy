class Api < ActiveRecord::Base
  belongs_to :account, inverse_of: :apis
  has_many :resources, inverse_of: :api, dependent: :destroy
  has_many :data_encodings, inverse_of: :api
  has_many :data_encoding_templates, inverse_of: :api

  accepts_nested_attributes_for :resources

  before_destroy { |api| api.data_encodings.empty? }

  def as_json(*args)
    Jbuilder.new do |json|
      json.(self,
        :id,
        :name,
        :install_url,
        :uninstall_url,
        :is_active
      )
      json.resources_attributes resources.map(&:as_json)
    end.attributes!
  end
end
