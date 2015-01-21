class V1::JobsController < ApiController
  include V1::ApiAuthorization

  before_action :verify_job

  def show
    render json: job, status: 200
  end

private

  def get_job
    if user.internal?
      Job
    else
      account.jobs
    end.find_by(id: params[:id])
  end

  def job
    @job ||= get_job
  end

  def verify_job
    render(
      json: { message: 'Please provide a valid id.' },
      status: :bad_request
    ) unless job
  end
end
