class V1::ApisController < ApiController
  include V1::ApiAuthorization

  def index
    render json: { apis: all_apis }, status: :ok
  end

  def create
    api = account.apis.create(create_params)
    render json: { api: api }, status: :ok
  end

private

  def create_params
    params.slice(:name, :install_url, :uninstall_url, :resources_attributes).as_json
  end

  def all_apis
    if account.internal?
      Api.all
    else
      account.apis
    end
  end

end
