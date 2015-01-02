class Api::V1::RequestsController < ActionController::Base
  respond_to :json
  before_action :authorize!

private

  def token
    @token ||= (request.headers
      .fetch("HTTP_AUTHENTICATION", "")
      .match(/Token (.*)/) || [])[1]
  end

  def data_encoding
    @data_encoding ||= DataEncoding.find_by(token: token)
  end

  def installed_api
    data_encoding.installed_api if data_encoding
  end

  def authorize!
    head :unauthorized unless installed_api
  end
end
