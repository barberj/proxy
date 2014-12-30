class Api::V1::GetRequestsController < Api::V1::RequestsController

  MISSING_PARAM = %q(Get Requests Params must include either created_since, updated_since, identifiers, or search_by.)
  UNSUPPORTED_ACTION = %q(Can not request %{type} for %{api}'s %{resource}.)

  def index
    status, results = process_request(params)
    render json: results, status: status
  end

  InvalidTimeFormat = Class.new StandardError

private

  def process_request(params)
    case
    when params[:updated_since]
      accept_job(:updated, params[:resource], updated_params)
    when params[:created_since]
      accept_job(:created, params[:resource], created_params)
    when params[:identifiers]
      accept_job(:identifiers, params[:resource], identifiers_params)
    when params[:search_by]
      accept_job(:search, params[:resource], search_params)
    else
      [
        :bad_request,
        message: MISSING_PARAM
      ]
    end
  rescue InvalidTimeFormat => ex
    [
      :bad_request,
      message: ex.message
    ]
  end

  def accept_job(request_type, resource, params)
    if installed_api.send(:"can_request_#{request_type}?", resource)
      [
        :accepted,
        results: { job_id: 1 }
      ]
    else
      [
        :unprocessable_entity,
        message: UNSUPPORTED_ACTION % {
          api: installed_api.name,
          type: request_type,
          resource: resource.capitalize
        }
      ]
    end
  end

  def verify_time(key)
    Time.strptime(params[key], '%FT%T%z').utc
  rescue
    raise InvalidTimeFormat.new(
      %Q(#{key} requires format "YYYY-mm-ddTHH:MM:SS-Z")
    )
  end

  def created_params
    verify_time(:created_since)
    params.permit(
      :created_since,
      :page,
      :limit
    )
  end

  def updated_params
    verify_time(:updated_since)
    params.permit(
      :updated_since,
      :page,
      :limit
    )
  end

  def identifiers_params
    params.permit(
      :identifiers => []
    )
  end

  def search_params
    params[:search_by]
  end
end
