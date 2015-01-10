class Api::V1::PostRequestsController < Api::V1::RequestsController
  def create
    accept_request(:create, params[:encoded_resource], create_params)
  end

private

  def create_params
    { data: Array.wrap(params.require(:data)) }
  end
end