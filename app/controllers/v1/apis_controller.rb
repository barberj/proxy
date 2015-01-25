class V1::ApisController < ApiController
  include V1::ApiAuthorization

  before_action :verify_api, only: [:destroy]

  def index
    render json: all_apis, status: :ok
  end

  def create
    api = account.apis.create(create_params)
    render json: api, status: :ok
  end

  def image
    image = params['image'].tempfile.read()
    if api = account.apis.find_by(id: api_id)
      api.image = image
      api.save
    end

    render json: api, status: :ok
  end

  def destroy
    if api.destroy
      render json: { api: api }, status: :ok
    else
      render(
        json: { message: 'Unable to delete an API which has been installed. Please contact support.' },
        status: :locked
      )
    end
  end

private

  def api_id
    params.require(:api_id)
  end

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

  def get_api
    if user.internal?
      Api
    else
      account.apis
    end.find_by(id: params[:id])
  end

  def api
    @api ||= get_api
  end

  def verify_api
    render(
      json: { message: 'Please provide a valid id.' },
      status: :bad_request
    ) unless api
  end

end
