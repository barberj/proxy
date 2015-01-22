class UsersController < AuthenticatedController
  skip_before_action :authenticate_user!, :only => [:new]

  def new
    redirect_to dashboard_index_path if signed_in?
  end
end
