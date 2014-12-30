class Api::V1::InternalApiController < ActionController::Base
  respond_to :json
  before_action :authorize!

private

  def token
    @token ||= (request.headers
      .fetch("HTTP_AUTHENTICATION", "")
      .match(/Token (.*)/) || [])[1]
  end

  def account
    #@account ||= Account.find_by(token: token)
  end

  def authorize!
    #head :unauthorized unless api
  end
end
