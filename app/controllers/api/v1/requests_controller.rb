class Api::V1::RequestsController < ActionController::Base
  respond_to :json
  before_action :authorize!

private

  def token
    @token ||= (request.headers
      .fetch("HTTP_AUTHENTICATION", "")
      .match(/Token (.*)/) || [])[1]
  end

  def installed_api
    @installed_api ||= InstalledApi.find_by(local_token: token)
  end

  def authorize!
    head :unauthorized unless installed_api
  end
end
