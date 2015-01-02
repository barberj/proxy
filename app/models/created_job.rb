class CreatedJob < Job
  belongs_to :resource
  belongs_to :encoded_resource

  def process
    request_created
    encode_data
  end

  def request_created
    self.status = 'requesting'
    self.save

    rsp = request(:get, resource.created_url,
      :query   => created_params,
      :headers => {
        'Authorization' => "Token #{installed_api.token}"
      }
    )

    self.results = rsp
    self.status = 'encoding' if rsp.code >= 200 && rsp.code < 300
    self.save
  end

  def encode_data
    encoded = []
    Array.wrap(self.results['results']).each do |data|
      encoded_datum = {}
      encoded_resource.encoded_fields.each do |encoded_field|
        if value = encoded_field.value_from_api(data)
          Dpaths.dput(encoded_datum, encoded_field.dpath, value)
        end
      end
      encoded << encoded_datum if encoded_datum.present?
    end

    if encoded.present?
      self.results = self.results.merge(results: encoded)
      self.save
    end
  end


private
  def created_params
    page = self.params['page'] || 1
    limit = self.params['limit'] || 250

    self.params.merge(
      page: page,
      limit: [limit.to_i, 250].min,
    )
  end
end
