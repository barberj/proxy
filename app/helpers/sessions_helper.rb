module SessionsHelper
  def sign_in(user)
    session[:user_id] = user.id
    session[:internal_user_id] = user.id if user.internal?
    user.last_signin_at = Time.now
    user.save
  end

  def sign_out
    reset_session
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_user_token
    current_user.token if current_user
  end

  def current_user_id
    current_user.id if current_user
  end

  def signed_in?
    Rails.logger.debug "signed in? #{current_user.present?}"
    current_user.present?
  end
end
