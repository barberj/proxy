class UsersController < ApplicationController
  def new; end

  def create
    user = User.new(create_params)
    status = if user.valid?
      user.account = Account.create
      user.save
      :created
    else
      :bad_request
    end

    render json: nil, status: status
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
