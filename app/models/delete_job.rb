class DeleteJob < Job

  def process
    del_data
    encode_data
  rescue => ex
    Rails.logger.warn("Errored while processing Job #{self.id}")
    self.status = 'errored'
    self.save
  end

  def del_data
    self.status = 'requesting'
    self.save

    rsp = request(:delete, resource.delete_url,
      :body => params.to_json,
      :headers => {
        'Authorization' => "Token #{data_encoding.token}",
        'Content-Type'  => 'application/json'
      }
    )

    self.results = rsp
    self.status = 'encoding' if rsp.code >= 200 && rsp.code < 300
    self.save
  end
end
