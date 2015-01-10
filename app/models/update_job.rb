class UpdateJob < SetJob
  def data_url
    resource.update_url
  end

  def job_method
    :put
  end
end
