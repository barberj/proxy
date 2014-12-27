class SessionsController < ApplicationController

  def new; end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      # If user's sign in doesn't work, send them back to the sign in form.
      redirect_to signin_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to signin_path
  end

end
