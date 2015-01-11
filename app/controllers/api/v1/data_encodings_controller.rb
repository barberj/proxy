class Api::V1::DataEncodingsController < Api::V1::InternalApiController

  def index
    render json: { data_encodings: account.data_encodings}, status: :ok
  end
end
