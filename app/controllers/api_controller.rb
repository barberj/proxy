class ApiController < ActionController::Base
  respond_to :json

  def internal?
    user.internal?
  end
end
