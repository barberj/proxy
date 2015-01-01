module ResourceRequests
  extend ActiveSupport::Concern

  def can_request_updated?(resource)
  end

  def can_request_created?(resource)
    binding.pry
    puts
  end

  def reads_one?(resource)
  end

  def reads_many?(resource)
  end

  def can_request_identifiers?(resource)
  end

  def can_request_search?(resource)
  end
end
