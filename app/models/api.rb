class Api < ActiveRecord::Base
  belongs_to :account, inverse_of: :apis
  has_many :resources, inverse_of: :api
  has_many :data_encodings, inverse_of: :api

  accepts_nested_attributes_for :resources

  def as_json(*args)
    Jbuilder.new do |json|
      json.(self,
        :id,
        :name,
        :install_url,
        :uninstall_url,
        :is_active
      )
    end.attributes!
  end
end
