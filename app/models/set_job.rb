class SetJob < Job

  def process
    set_data
    encode_data
  end

  def job_method
    raise NotImplementedError
  end

private

  def set_data
    self.status = 'requesting'
    self.save

    rsp = request(job_method, data_url,
      :body => body,
      :headers => {
        'Authorization' => "Token #{data_encoding.token}",
        'Content-Type'  => 'application/json'
      }
    )

    self.results = rsp
    self.status = 'encoding' if rsp.code >= 200 && rsp.code < 300
    self.save
  end

  def compile_body
    {
      data: [].tap do |decoded|
        Array.wrap(self.params['data']).each do |data|
          decoded_datum = {}
          encoded_resource.encoded_fields.each do |encoded_field|
            if value = encoded_field.value_from_user(data)
              encoded_field.value_to_api(decoded_datum, value)
            end
          end
        decoded << decoded_datum if decoded_datum.present?
        end
      end
    }.to_json
  end

  def body
    from_redis(:body) { compile_body }
  end
end
