class Api::V1::RequestsController < ActionController::Base
  respond_to :json
  before_action :authorize!

private

  def token
    @token ||= (request.headers
      .fetch("HTTP_AUTHENTICATION", "")
      .match(/Token (.*)/) || [])[1]
  end

  def installed_api_encoding
    @installed_api_encoding ||= DataEncoding.find_by(token: token)
  end

  def authorize!
    head :unauthorized unless installed_api_encoding
  end
end
