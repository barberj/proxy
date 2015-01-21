require 'rails_helper'

describe 'Apis' do
  context 'list' do
    it 'returns APIs' do
      get(v1_apis_path, nil,
        'HTTP_AUTHORIZATION' => "Token #{user_token}"
      )
      expect(json['apis']).to be_present
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
end
