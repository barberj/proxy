class Api::V1::InternalApiController < ActionController::Base
  respond_to :json
  before_action :authorize_user!

private

  def token
    @token ||= (request.headers
      .fetch("HTTP_AUTHENTICATION", "")
      .match(/Token (.*)/) || [])[1]
  end

  def user
    @user ||= User.find_by(token: token)
  end

  def account
    @account ||= user.account
  end

  def authorize_user!
    head :unauthorized unless user
  end
end
