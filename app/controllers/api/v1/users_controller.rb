class Api::V1::UsersController < Api::V1::InternalApiController
  skip_before_action :authorize_user!, :only => [:create]

  def create
    user = User.new(create_params)
    status = if user.valid?
      user.account = Account.create
      user.save
      :created
    else
      :bad_request
    end

    render json: user.errors, status: status
  end

private

  def create_params
    params.require(:first_name)
    params.require(:last_name)
    params.require(:email)
    params.require(:password)

    params.permit(
      :first_name,
      :last_name,
      :email,
      :password
    )
  end
end
