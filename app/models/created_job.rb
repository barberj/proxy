class CreatedJob < GetJob
  def data_url
    resource.created_url
  end
end
