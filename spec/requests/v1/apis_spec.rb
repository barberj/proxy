require 'rails_helper'

describe 'Apis' do
  context 'list' do
    it 'returns APIs' do
      get(v1_apis_path, nil,
        'HTTP_AUTHORIZATION' => "Token #{user_token}"
      )
      expect(json).to be_present
    end
    it 'includes resources_attributes' do
      get(v1_apis_path, nil,
        'HTTP_AUTHORIZATION' => "Token #{user_token}"
      )
      api = json['apis'].first
      expect(api.keys).to include( 'resources_attributes' )
    end
    it 'includes fields_attributes' do
      get(v1_apis_path, nil,
        'HTTP_AUTHORIZATION' => "Token #{user_token}"
      )
      resource = json['apis'].first['resources_attributes'].first
      expect(resource.keys).to include( 'fields_attributes' )
    end
  end
  context 'destroy' do
    it 'deletes APIs' do
      DataEncoding.destroy_all

      rsp = delete(v1_api_path(Api.first), nil,
        'HTTP_AUTHORIZATION' => "Token #{user_token}"
      )

      expect(rsp).to eq(200)
    end
    context 'when it has been installed' do
      it 'returns locked (423)' do
        rsp = delete(v1_api_path(Api.first), nil,
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )

        expect(rsp).to eq 423
      end
      it 'returns error message' do
        delete(v1_api_path(Api.first), nil,
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )

        expect(json['message']).
          to eq("Unable to delete an API which has been installed. Please contact support.")
      end
    end
  end
end
