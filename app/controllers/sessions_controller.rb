class SessionsController < ApplicationController

  def new; end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      sign_in(user)
      redirect_to dashboard_index_path
    else
      redirect_to signin_path
    end
  end

  def destroy
    sign_out
    redirect_to signin_path
  end

end
