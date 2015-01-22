class Resource < ActiveRecord::Base
  belongs_to :api, inverse_of: :resources
  has_many :fields, inverse_of: :resource, dependent: :destroy

  validates :name, presence: true,
                   uniqueness: { scope: :api_id }

  accepts_nested_attributes_for :fields

  def to_eh
    {
      resource_id: self.id,
      name: self.name,
      encoded_fields_attributes: self.fields.map(&:to_eh)
    }
  end

  def can_request?(request_type)
    send(:"#{request_type}_url").present?
  end

  def as_json(*args)
    Jbuilder.new do |json|
      json.(self,
        :id,
        :name,
        :customs_url,
        :search_url,
        :created_url,
        :updated_url,
        :read_url,
        :create_url,
        :update_url,
        :delete_url
      )
      json.fields_attributes fields.map(&:as_json)
    end.attributes!
  end
end
