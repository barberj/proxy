require 'rails_helper'

describe 'GetRequests' do
  context 'for DataEncoding with action' do
    before { create_api }
    context 'with created_since params' do
      let(:get_created_request) do
        get(api_v1_path('Contacts'),
          {
            :created_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%FT%T%z'),
            :data_encoding_id => default_data_encoding.id
          },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )
      end
      it 'returns job id' do
        get_created_request

        expect(json['results']['job_id']).to eq Job.first.id
      end
      it 'creates a CreatedJob' do
        expect{
          get_created_request
        }.to change{
          CreatedJob.count
        }.by 1
      end
      it 'returns accepted status (202)' do
        expect(get_created_request).to eq 202
      end
    end
    context 'with updated_since params' do
      let(:get_updated_request) do
        get(api_v1_path('Contacts'),
          {
            :updated_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%FT%T%z'),
            :data_encoding_id => default_data_encoding.id
          },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )
      end
      it 'returns job id' do
        get_updated_request

        expect(json['results']['job_id']).to eq Job.first.id
      end
      it 'creates a UpdatedJob' do
        expect{
          get_updated_request
        }.to change{
          UpdatedJob.count
        }.by 1
      end
      it 'returns accepted status (202)' do
        expect(get_updated_request).to eq 202
      end
    end
    context 'with identifiers params' do
      let(:get_identifiers_request) do
        get(api_v1_path('Contacts'),
          {
            :identifiers => [1],
            :data_encoding_id => default_data_encoding.id
          },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )
      end
      it 'returns job id' do
        get_identifiers_request

        expect(json['results']['job_id']).to eq Job.first.id
      end
      it 'creates a ReadJob' do
        expect{
          get_identifiers_request
        }.to change{
          ReadJob.count
        }.by 1
      end
      it 'returns accepted status (202)' do
        expect(get_identifiers_request).to eq 202
      end
    end
    context 'with search_by params' do
      let(:get_search_request) do
        get(api_v1_path('Contacts'),
          {
            :search_by => {:email => 'some_user@email.com' },
            :data_encoding_id => default_data_encoding.id
          },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )

      end
      it 'returns job id' do
        get_search_request

        expect(json['results']['job_id']).to eq Job.first.id
      end
      it 'creates a ReadJob' do
        expect{
          get_search_request
        }.to change{
          SearchJob.count
        }.by 1
      end
      it 'returns accepted status (202)' do
        expect(get_search_request).to eq 202
      end
    end
    context 'with invalid token' do
      it 'returns unauthorized status (401)' do
        expect(get(api_v1_path('Contacts'),
          {
            search_by: {email: 'some_user@email.com' },
            :data_encoding_id => default_data_encoding.id
          },
          'HTTP_AUTHORIZATION' => "Token bad_token"
        )).to eq 401
      end
    end
    context 'with invalid encoding_id' do
      it 'returns unauthorized status (401)' do
        expect(get(api_v1_path('Contacts'),
          {
            search_by: {email: 'some_user@email.com' },
            :data_encoding_id => 999
          },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )).to eq 401
      end
    end
    context 'when missing params' do
      let(:get_request_missing_params) do
        get(api_v1_path('Contacts'),
          {
            :data_encoding_id => default_data_encoding.id
          },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )
      end
      it 'returns bad_request status (400)' do
        expect(get_request_missing_params).to eq 400
      end
      it 'returns missing param message' do
        get_request_missing_params

        expect(json['message']).to eq(
          %q(Get Requests Params must include either created_since, updated_since, identifiers, or search_by.)
        )
      end
    end
    context 'when given bad params' do
      let(:get_request_with_bad_params) do
        get(api_v1_path('Contacts'),
          {
            :updated_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%F %T'),
            :data_encoding_id => default_data_encoding.id
          },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )
      end
      it 'returns bad_request status (400)' do
        expect(get_request_with_bad_params).to eq 400
      end
      it 'returns missing param message' do
        get_request_with_bad_params

        expect(json['message']).to eq(
          "updated_since requires format \"YYYY-mm-ddTHH:MM:SS-Z\""
        )
      end
    end
    context 'with custom encoding' do
      let(:get_request_for_custom) do
        get(api_v1_path('MyContacts'),
          {
            :created_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%FT%T%z'),
            :data_encoding_id => custom_data_encoding.id
          },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )
      end
      it 'returns job id' do
        get_request_for_custom

        expect(json['results']['job_id']).to eq Job.first.id
      end
      it 'creates a CreatedJob' do
        expect{
          get_request_for_custom
        }.to change{
          CreatedJob.count
        }.by 1
      end
      it 'returns accepted status (202)' do
        expect(get_request_for_custom).to eq 202
      end
      it 'returns unprocessable_entity status (422) for invalid resource' do
        expect(get(api_v1_path('Contacts'),
          {
            :created_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%FT%T%z'),
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
          updated_url: 'https://remoteapi.com/updated',
          create_url: 'https://remoteapi.com/create',
          update_url: 'https://remoteapi.com/update',
          delete_url: 'https://remoteapi.com/delete',
          read_url: 'https://remoteapi.com/read',
          fields_attributes: [{
            dpath: '/first_name'
          }]
        }]
      )
    end
    it 'returns unprocessable_entity status (422)' do
      rsp = get(api_v1_path('Contacts'),
        {
          :created_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%FT%T%z'),
          :data_encoding_id => account.data_encodings.last.id
        },
        'HTTP_AUTHORIZATION' => "Token #{user_token}"
      )

      expect(rsp).to eq 422
    end
    it 'returns unsupported action message' do
      get(api_v1_path('Contacts'),
        {
          :created_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%FT%T%z'),
          :data_encoding_id => account.data_encodings.last.id
        },
        'HTTP_AUTHORIZATION' => "Token #{user_token}"
      )

      expect(json['message']).to eq(
        "Can not request created for Development RemoteApi's Contacts."
      )
    end
  end
end
