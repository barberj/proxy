class Api::V1::InstalledApisController < Api::V1::InternalApiController

  def index
    render json: { installed_apis: account.installed_apis }, status: :ok
  end
end
