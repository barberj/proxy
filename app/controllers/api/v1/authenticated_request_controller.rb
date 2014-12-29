class Api::V1::AuthenticatedRequestController < Api::V1::RequestController
  before_action :authenticate!

private

  def authenticate!
  end
end
