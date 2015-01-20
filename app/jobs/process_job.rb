class ProcessJob < ActiveJob::Base

  def perform(job)
    job.process
  end
end
