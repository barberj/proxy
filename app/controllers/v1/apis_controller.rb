class V1::ApisController < ApiController
  include V1::ApiAuthorization

  skip_before_action :authorize_user!, :only => [:get_image]
  before_action :verify_api, only: [:update, :destroy]

  def index
    render json: {apis: all_apis}, status: :ok
  end

  def create
    api = account.apis.create(upsert_params)
    render json: api, status: :ok
  end

  def update
    api.update(upsert_params)

    render json: api, status: :ok
  end

  def add_image
    image = params['image'].tempfile.read()
    if api = account.apis.find_by(id: api_id)
      api.image = image
      api.save
    end

    render json: api, status: :ok
  end

  def get_image
    if api = account.apis.find_by(id: api_id)
      render json: {api_id: api_id, image: api.image}, status: :ok
    else
      render json: {message: 'Invalid API'}, status: :bad_request
    end

  end

  def destroy
    if api.destroy
      render json: { message: "Deleted API #{api.id}" }, status: :ok
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

  def upsert_params
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
