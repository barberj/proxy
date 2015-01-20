module V1::ApiAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :authorize_user!
  end

private

  def token
    @token ||= (request.headers
      .fetch("HTTP_AUTHORIZATION", "")
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
