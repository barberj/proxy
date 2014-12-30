class Api::V1::AuthenticatedRequestsController < Api::V1::RequestsController
  before_action :authenticate!

private

  def authenticate!
  end
end
