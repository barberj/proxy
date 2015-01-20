class V1::PutDataController < V1::EncodedDataController

  def update
    accept_job(:update, params[:encoded_resource], update_params)
  end

private

  def update_params
    { data: Array.wrap(params.require(:data)) }
  end
end
