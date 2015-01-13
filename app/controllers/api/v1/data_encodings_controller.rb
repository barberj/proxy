class Api::V1::DataEncodingsController < Api::V1::InternalApiController

  def index
    render json: { data_encodings: account.data_encodings}, status: :ok
  end

  def update
    updated = if encoding = account.data_encodings.find_by(:id => params[:id])
      encoding.update_attributes(update_params)
    end

    render json: encoding, status: :ok
  end

private

  def update_params
    params.slice(:id, :name, :encoded_resources_attributes).as_json
  end
end
