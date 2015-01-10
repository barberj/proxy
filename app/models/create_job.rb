class CreateJob < SetJob
  def data_url
    resource.create_url
  end

  def job_method
    :post
  end
end
