class Api::V1::MarketPlaceController < Api::V1::InternalApiController

  def index
    render json: { apis: Api.all}, status: :ok
  end

  def create
    installed = account.installed_apis.create( install_params )
    render json: { installed_api: installed }, status: :ok
  end

private

  def install_params
    params.require(:api_id)
    params.permit(*InstalledApi.attribute_names).
      except(
        :account_id,
        :token,
        :is_dev,
        :created_at,
        :updated_at
      )
  end
end
