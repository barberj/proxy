class Api::V1::GetRequestsController < Api::V1::RequestsController

  MISSING_PARAM = %q(Get Requests Params must include either created_since, updated_since, identifiers, or search_by.)

  def index
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
      raise Exceptions::BadRequest.new MISSING_PARAM
    end
  end

private

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

      render(
        json: { results: { job_id: job.id } },
        status: :accepted,
      )
    else
      raise Exceptions::Unprocessable.new(UNSUPPORTED_ACTION % {
        api: installed_api.name,
        type: request_type,
        encoded_resource: encoded_name.capitalize,
      })
    end
  end

  def verify_time(key)
    Time.strptime(params[key], '%FT%T%z').utc
  rescue
    raise Exceptions::BadRequest.new(
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
    criteria = params[:search_by]
    raise Exceptions::BadRequest.new('search_by requires criteria') if criteria.empty?
    {'search_by' => criteria}
  end
end
