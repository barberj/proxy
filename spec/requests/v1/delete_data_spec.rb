require 'rails_helper'

describe 'DeleteData' do
  context 'for DataEncoding with action' do
    before { create_api }
    context 'with data params' do
      let(:delete_request) do
        delete(v1_path('Contacts'),
          {
            :identifiers => [1],
            :data_encoding_id => default_data_encoding.id
          },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )
      end
      it 'returns job id' do
        delete_request

        expect(json['results']['request_id']).to eq Job.first.id
      end
      it 'creates a DeleteJob' do
        expect{
          delete_request
        }.to change{
          DeleteJob.count
        }.by 1
      end
      it 'returns accepted status (202)' do
        expect(delete_request).to eq 202
      end
      it 'saves params to Job' do
        delete_request
        job = DeleteJob.last

        expect(job.params).to include('identifiers')
        expect(job.params['identifiers']).to eq(["1"])
      end
    end
    context 'with invalid token' do
      it 'returns unauthorized status (401)' do
        expect(delete(v1_path('Contacts'),
          {
            :identifiers      => [1],
            :data_encoding_id => default_data_encoding.id
          },
          'HTTP_AUTHORIZATION' => "Token bad_token"
        )).to eq 401
      end
    end
    context 'with invalid encoding_id' do
      it 'returns unauthorized status (401)' do
        expect(delete(v1_path('Contacts'),
          {
            :identifiers      => [1],
            :data_encoding_id => 999
          },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )).to eq 401
      end
    end
    context 'when missing identifiers' do
      let(:delete_request_missing_identifiers) do
        delete(v1_path('Contacts'),
          {
            :data_encoding_id => default_data_encoding.id
          },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )
      end
      it 'returns bad_request status (400)' do
        expect(delete_request_missing_identifiers).to eq 400
      end
      it 'returns missing identifiers message' do
        delete_request_missing_identifiers

        expect(json['message']).to eq(
          %q(Delete request must include identifiers.)
        )
      end
    end
    context 'with custom encoding' do
      let(:delete_request_for_custom) do
        delete(v1_path('MyContacts'),
          {
            :identifiers      => [1],
            :data_encoding_id => custom_data_encoding.id
          },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )
      end
      it 'returns job id' do
        delete_request_for_custom

        expect(json['results']['request_id']).to eq Job.first.id
      end
      it 'creates a DeleteJob' do
        expect{
          delete_request_for_custom
        }.to change{
          DeleteJob.count
        }.by 1
      end
      it 'returns accepted status (202)' do
        expect(delete_request_for_custom).to eq 202
      end
      it 'saves encoded params to Job' do
        delete_request_for_custom
        job = DeleteJob.last

        expect(job.params).to include('identifiers')
        expect(job.params['identifiers']).to eq(["1"])
      end
      it 'returns unprocessable_entity status (422) for invalid resource' do
        expect(delete(v1_path('Contacts'),
          {
            :identifiers => [1],
            :data_encoding_id => custom_data_encoding.id
          },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )).to eq 422
      end
    end
  end
  context 'for DataEncoding without action' do
    before do
      api = account.apis.create(
        name: 'RemoteApi',
        install_url: 'https://remoteapi.com/install',
        uninstall_url: 'https://remoteapi.com/uninstall',
        resources_attributes: [{
          name: 'Contacts',
          customs_url: 'https://remoteapi.com/customs',
          search_url: 'https://remoteapi.com/search',
          created_url: 'https://remoteapi.com/created',
          updated_url: 'https://remoteapi.com/updated',
          read_url: 'https://remoteapi.com/read',
          create_url: 'https://remoteapi.com/create',
          update_url: 'https://remoteapi.com/update',
          fields_attributes: [{
            dpath: '/first_name'
          }]
        }]
      )
      account.install_api(api)
    end
    let(:delete_request) do
      delete(v1_path('Contacts'),
        {
          :identifiers => [1],
          :data_encoding_id => account.data_encodings.last.id
        },
        'HTTP_AUTHORIZATION' => "Token #{user_token}"
      )
    end
    it 'returns unprocessable_entity status (422)' do
      expect(delete_request).to eq 422
    end
    it 'returns unsupported action message' do
      delete_request

      expect(json['message']).to eq(
        "Can not request delete for RemoteApi Encoding's Contacts."
      )
    end
  end
end
