class CreateJob < Job
  def process
    set_data
    encode_data
  end

private

  def set_data
    self.status = 'requesting'
    self.save

    rsp = request(:get, data_url,
      :body => body,
      :headers => {
        'Authorization' => "Token #{installed_api.token}",
        'content-type'  => 'application/json'
      }
    )

    self.results = rsp
    self.status = 'encoding' if rsp.code >= 200 && rsp.code < 300
    self.save
  end

  def compile_body
    [].tap do |decoded_data|
      Array.wrap(self.params['data']).each do |data|
        decoded_datum = {}
        encoded_resource.encoded_fields.each do |encoded_field|
          if value = encoded_field.value_from_user(data)
            encoded_field.value_to_api(decoded_datum, value)
          end
        end
      encoded << encoded_datum if encoded_datum.present?
      end
    end
  end

  def body
    from_redis(:body) { compile_body }
  end
end
