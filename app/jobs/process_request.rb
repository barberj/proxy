class ProcessRequest < ActiveJob::Base

  def perform(request)
    request.process
  end
end
