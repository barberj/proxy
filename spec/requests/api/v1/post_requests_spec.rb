require 'rails_helper'

describe 'PostRequests' do
  context 'for DataEncoding with action' do
    before { create_api }
    context 'with data params' do
      let(:post_request) do
        post(api_v1_path('Contacts'),
          {
            :data => [{'FIRST_NAME' => 'Justin'}],
            :data_encoding_id => default_data_encoding.id
          },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )
      end
      it 'returns job id' do
        post_request

        expect(json['results']['job_id']).to eq Job.first.id
      end
      it 'creates a CreateJob' do
        expect{
          post_request
        }.to change{
          CreateJob.count
        }.by 1
      end
      it 'returns accepted status (202)' do
        expect(post_request).to eq 202
      end
      it 'saves params to Job' do
        post_request
        job = CreateJob.last

        expect(job.params).to include('data')
        expect(job.params['data']).to eq(
          [{'FIRST_NAME' => 'Justin'}]
        )
      end
    end
    context 'with invalid token' do
      it 'returns unauthorized status (401)' do
        expect(post(api_v1_path('Contacts'),
          {
            :data => [{'FIRST_NAME' => 'Justin'}],
            :data_encoding_id => default_data_encoding.id
          },
          'HTTP_AUTHORIZATION' => "Token bad_token"
        )).to eq 401
      end
    end
    context 'with invalid encoding_id' do
      it 'returns unauthorized status (401)' do
        expect(post(api_v1_path('Contacts'),
          {
            :data => [{'FIRST_NAME' => 'Justin'}],
            :data_encoding_id => 999
          },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )).to eq 401
      end
    end
    context 'when missing data' do
      let(:post_request_missing_data) do
        post(api_v1_path('Contacts'),
          {
            :data_encoding_id => default_data_encoding.id
          },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )
      end
      it 'returns bad_request status (400)' do
        expect(post_request_missing_data).to eq 400
      end
      it 'returns missing data message' do
        post_request_missing_data

        expect(json['message']).to eq(
          %q(Post Requests must include data.)
        )
      end
    end
    context 'with custom encoding' do
      let(:post_request_for_custom) do
        post(api_v1_path('MyContacts'),
          {
            :data => [{'fname' => 'Justin'}],
            :data_encoding_id => custom_data_encoding.id
          },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )
      end
      it 'returns job id' do
        post_request_for_custom

        expect(json['results']['job_id']).to eq Job.first.id
      end
      it 'creates a CreateJob' do
        expect{
          post_request_for_custom
        }.to change{
          CreateJob.count
        }.by 1
      end
      it 'returns accepted status (202)' do
        expect(post_request_for_custom).to eq 202
      end
      it 'saves encoded params to Job' do
        post_request_for_custom
        job = CreateJob.last

        expect(job.params).to include('data')
        expect(job.params['data']).to eq(
          [{'fname' => 'Justin'}]
        )
      end
      it 'returns unprocessable_entity status (422) for invalid resource' do
        expect(post(api_v1_path('Contacts'),
          {
            :data => [{'FIRST_NAME' => 'Justin'}],
            :data_encoding_id => custom_data_encoding.id
          },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )).to eq 422
      end
    end
  end
  context 'for DataEncoding without action' do
    before do
      account.apis.create(
        name: 'RemoteApi',
        install_url: 'https://remoteapi.com/install',
        uninstall_url: 'https://remoteapi.com/uninstall',
        resources_attributes: [{
          name: 'Contacts',
          customs_url: 'https://remoteapi.com/customs',
          search_url: 'https://remoteapi.com/search',
          created_url: 'https://remoteapi.com/created',
          updated_url: 'https://remoteapi.com/updated',
          update_url: 'https://remoteapi.com/update',
          delete_url: 'https://remoteapi.com/delete',
          read_url: 'https://remoteapi.com/read',
          fields_attributes: [{
            dpath: '/first_name'
          }]
        }]
      )
    end
    let(:post_request) do
      post(api_v1_path('Contacts'),
        {
          :data => [{'FIRST_NAME' => 'Justin'}],
          :data_encoding_id => account.data_encodings.last.id
        },
        'HTTP_AUTHORIZATION' => "Token #{user_token}"
      )
    end
    it 'returns unprocessable_entity status (422)' do
      expect(post_request).to eq 422
    end
    it 'returns unsupported action message' do
      post_request

      expect(json['message']).to eq(
        "Can not request create for Development RemoteApi Encoding's Contacts."
      )
    end
  end
end
