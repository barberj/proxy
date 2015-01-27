class V1::EncodedDataController < ApiController
  include V1::ApiAuthorization

  before_action :authorize_request!
  include V1::JobAcceptance

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

  rescue_from ActionController::ParameterMissing do
    render(
      json: {
        message: %Q(#{request_method.capitalize} request must include data.)
      },
      status: :bad_request
    )
  end

private

  def request_method
    request.env['REQUEST_METHOD']
  end

  def get_encoding
    if internal?
      DataEncoding
    else
      account.data_encodings
    end.find_by(id: params[:data_encoding_id])
  end

  def data_encoding
    @data_encoding ||= get_encoding
  end

  def authorize_request!
    head :unauthorized unless data_encoding
  end
end
