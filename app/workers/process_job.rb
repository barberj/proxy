class ProcessJob
  include Sidekiq::Worker

  def perform(job_id:)
  end
end
