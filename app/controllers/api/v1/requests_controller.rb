class Api::V1::RequestsController < Api::V1::InternalApiController
  before_action :authorize_request!

  UNSUPPORTED_ACTION = %q(Can not request %{type} for %{api}'s %{encoded_resource}.)

  rescue_from Exceptions::BadRequest do |exception|
    render(
      json: { message: exception.message },
      status: :bad_request
    )
  end

  rescue_from Exceptions::Unprocessable do |exception|
    render(
      json: { message: exception.message },
      status: :unprocessable_entity,
    )
  end

private

  def get_encoding
    if user.internal?
      DataEncoding
    else
      account.data_encodings
    end.find_by(id: params[:data_encoding_id])
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
end
