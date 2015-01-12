class Api::V1::JobsController < Api::V1::InternalApiController
  before_action :verify_job!

  def index
    render json: job, status: 200
  end

private

  def get_job
    if user.internal?
      Job
    else
      account.jobs
    end.find_by(id: params[:job_id])
  end

  def job
    @job ||= get_job
  end

  def verify_job!
    render(
      json: { message: 'Please provide a valid job_id.' },
      status: :bad_request
    ) unless job
  end
end
