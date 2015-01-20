class V1::DeleteDataController < V1::EncodedDataController

  rescue_from ActionController::ParameterMissing do
    render(
      json: {
        message: %Q(#{request_method.capitalize} request must include identifiers.)
      },
      status: :bad_request
    )
  end

  def destroy
    accept_job(:delete, params[:encoded_resource], delete_params)
  end

private

  def delete_params
    { identifiers: Array.wrap(params.require(:identifiers)) }
  end
end
