class ReadJob < GetJob
  def data_url
    resource.read_url
  end
end
