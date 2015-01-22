class Account < ActiveRecord::Base
  has_many :users, inverse_of: :account
  has_many :apis, inverse_of: :account
  has_many :data_encodings, inverse_of: :account
  has_many :jobs, inverse_of: :account
  has_many :data_encoding_templates, inverse_of: :account

  def internal?
    self.id == 1
  end

  def data_encoding_template_for(api)
    template = self.data_encoding_templates.where(:api_id => api.id).first_or_create
    template.encoded_attributes ||= api.resources.map(&:to_eh)
    template.save if template.changed?
    template
  end

  def install_api(api)
    template = data_encoding_template_for(api)

    self.data_encodings.create(
      name: "#{api.name} Encoding",
      api_id: api.id,
      encoded_resources_attributes: template.encoded_attributes
    )
  end
end
