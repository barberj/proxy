class V1::MarketplaceController < ApiController
  include V1::ApiAuthorization
  skip_before_action :authorize_user!, :only => [:index]

  def index
    render json: { apis: Api.where(is_active: true).all }, status: :ok
  end

  def create
    if api = Api.find_by(id: api_id)
      installed = account.install_api(api)
    else
      #raise something
    end
    render json: { data_encoding: installed }, status: :ok
  end

private

  def api_id
    params.require(:api_id)
  end
end
