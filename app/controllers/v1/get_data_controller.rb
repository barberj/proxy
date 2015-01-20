class V1::GetDataController < V1::EncodedDataController

  MISSING_PARAM = %q(Get request must include either created_since, updated_since, identifiers, or search_by.)

  def index
    case
    when params[:updated_since]
      accept_job(:updated, params[:encoded_resource], updated_params)
    when params[:created_since]
      accept_job(:created, params[:encoded_resource], created_params)
    when params[:identifiers]
      accept_job(:read, params[:encoded_resource], identifiers_params)
    when params[:search_by]
      accept_job(:search, params[:encoded_resource], search_params)
    else
      raise Exceptions::BadRequest.new MISSING_PARAM
    end
  end

private

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
