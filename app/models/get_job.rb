class GetJob < Job
  def process
    get_data
    encode_data
  end

private

  def get_data
    self.status = 'requesting'
    self.save

    rsp = request(:get, data_url,
      :query   => query_params,
      :headers => {
        'Authorization' => "Token #{installed_api.token}"
      }
    )

    self.results = rsp
    self.status = 'encoding' if rsp.code >= 200 && rsp.code < 300
    self.save
  end

  def compile_query_params
    page = self.params['page'] || 1
    limit = self.params['limit'] || 250

    self.params.merge(
      page: page,
      limit: [limit.to_i, 250].min,
    )
  end

  def query_params
    from_redis(:query_params) { compile_query_params }
  end
end
