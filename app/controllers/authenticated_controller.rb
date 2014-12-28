class AuthenticatedController < ApplicationController
  before_action :authenticate_user!

  def authenticate_user!
    redirect_to signin_url if !signed_in?
  end
end
