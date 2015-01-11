class Api::V1::InstalledApisController < Api::V1::InternalApiController

  def index
    render json: { apis: account.installed_apis }, status: :ok
  end
end
