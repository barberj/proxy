class UpdatedJob < GetJob
  def data_url
    resource.updated_url
  end
end
