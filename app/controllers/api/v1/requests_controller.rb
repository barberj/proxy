class Api::V1::RequestsController < Api::V1::InternalApiController
  before_action :authorize_request!

private

  def get_encoding
    if user.internal?
      DataEncoding
    else
      account.data_encodings
    end.find_by(id: data_encoding_id)
  end

  def data_encoding
    @data_encoding ||= get_encoding
  end

  def installed_api
    data_encoding.installed_api if data_encoding
  end

  def authorize_request!
    head :unauthorized unless installed_api
  end

private

  def data_encoding_id
    params[:data_encoding_id]
  end
end
