class CreatedJob < Job
  belongs_to :resource

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
