class V1::MarketplaceController < ApiController
  include V1::ApiAuthorization

  def index
    render json: { apis: Api.all}, status: :ok
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