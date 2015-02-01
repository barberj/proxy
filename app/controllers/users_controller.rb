class UsersController < AuthenticatedController
  skip_before_action :authenticate_user!, :only => [:new]
  respond_to :json, :only => [:update]

  def new
    redirect_to dashboard_index_path if signed_in?
  end

  def update
    if user.authenticate(current_password)
      user.password = new_password
      if user.save
        render json: {message: 'Updated password'}, status: :ok
      else
        render json: user.errors, status: :bad_request
      end
    else
      render json: {message: 'Invalid password'}, status: :unauthorized
    end
  end

private

  def user_id
    params.require(:id)
  end

  def current_password
    params.require(:current_password)
  end

  def new_password
    params.require(:new_password)
  end

  def user
    @user ||= User.find(user_id)
  end
end
