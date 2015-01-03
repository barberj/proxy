class Api::V1::JobsController < Api::V1::InternalApiController
  before_action :verify_job!

  def index
    render json: job, status: :ok
  end

private
  def job
    @job ||= account.jobs.find_by(id: params[:job_id])
  end

  def verify_job!
    render(
      json: { message: 'Please provide a valid job_id.' },
      status: :bad_request
    ) unless job
  end
end
