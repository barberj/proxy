class Api::V1::GetRequestsController < Api::V1::RequestsController

  MISSING_PARAM = %q(Get Requests Params must include either created_since, updated_since, identifiers, or search_by.)
  UNSUPPORTED_ACTION = %q(Can not request %{type} for %{api}'s %{encoded_resource}.)

  def index
    status, results = evaluate_request(params)
    render json: results, status: status
  end

  InvalidTimeFormat = Class.new StandardError

private

  def evaluate_request(params)
    case
    when params[:updated_since]
      accept_request(:updated, params[:encoded_resource], updated_params)
    when params[:created_since]
      accept_request(:created, params[:encoded_resource], created_params)
    when params[:identifiers]
      accept_request(:read, params[:encoded_resource], identifiers_params)
    when params[:search_by]
      accept_request(:search, params[:encoded_resource], search_params)
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

  def accept_request(request_type, encoded_name, params)
    if encoded_resource = data_encoding.encoded_resource_for(encoded_name, request_type)
      job = data_encoding.jobs.create(
        type: "#{request_type.to_s.capitalize}Job",
        params: params,
        resource_id: encoded_resource.resource.id,
        encoded_resource_id: encoded_resource.id,
        account_id: data_encoding.account_id
      )
      ProcessRequest.perform_later(job)
      [
        :accepted,
        results: { job_id: job.id }
      ]
    else
      [
        :unprocessable_entity,
        message: UNSUPPORTED_ACTION % {
          api: installed_api.name,
          type: request_type,
          encoded_resource: encoded_name.capitalize,
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
