class V1::DataEncodingsController < ApiController
  include V1::ApiAuthorization

  before_action :verify_encoding, only: [:destroy]

  def index
    render json: { data_encodings: account.data_encodings}, status: :ok
  end

  def update
    if encoding = account.data_encodings.find_by(:id => params[:id])
      if encoding.update(update_params)

        if params['template']
          template = account.data_encoding_templates.
            where(:api_id => encoding.api_id).first_or_create

          template.encoded_attributes = encoding.as_template
          template.save
        end
      end
    end

    render json: encoding, status: :ok
  end

  def destroy
    data_encoding.destroy
    render json: { message: "Deleted DataEncoding #{data_encoding.id}" }, status: :ok
  end

private

  def update_params
    params.slice(:id, :name, :encoded_resources_attributes).as_json
  end

  def get_data_encoding
    if user.internal?
      DataEncoding
    else
      account.data_encodings
    end.find_by(id: params[:id])
  end

  def data_encoding
    @data_encoding ||= get_data_encoding
  end

  def verify_encoding
    render(
      json: { message: 'Please provide a valid id.' },
      status: :bad_request
    ) unless data_encoding
  end
end
