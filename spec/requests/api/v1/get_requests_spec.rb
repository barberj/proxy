require 'rails_helper'

describe 'GetRequests' do
  context 'for DataEncoding with action' do
    before { create_api }
    context 'with created_since params' do
      it 'returns job id' do
        get(api_v1_path('Contacts'),
          { :created_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%FT%T%z') },
          'HTTP_AUTHENTICATION' => "Token #{token}"
        )

        expect(json['results']['job_id']).to eq Job.first.id
      end
      it 'creates a CreatedJob' do
        expect{
          get(api_v1_path('Contacts'),
            { :created_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%FT%T%z') },
            'HTTP_AUTHENTICATION' => "Token #{token}"
          )
        }.to change{
          CreatedJob.count
        }.by 1
      end
      it 'returns accepted status (202)' do
        rsp = get(api_v1_path('Contacts'),
          { :created_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%FT%T%z') },
          'HTTP_AUTHENTICATION' => "Token #{token}"
        )

        expect(rsp).to eq 202
      end
    end
    context 'with updated_since params' do
      it 'returns job id' do
        get(api_v1_path('Contacts'),
          { :updated_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%FT%T%z') },
          'HTTP_AUTHENTICATION' => "Token #{token}"
        )

        expect(json['results']['job_id']).to eq Job.first.id
      end
      it 'creates a UpdatedJob' do
        expect{
          get(api_v1_path('Contacts'),
            { :updated_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%FT%T%z') },
            'HTTP_AUTHENTICATION' => "Token #{token}"
          )
        }.to change{
          UpdatedJob.count
        }.by 1
      end
      it 'returns accepted status (202)' do
        rsp = get(api_v1_path('Contacts'),
          { :updated_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%FT%T%z') },
          'HTTP_AUTHENTICATION' => "Token #{token}"
        )

        expect(rsp).to eq 202
      end
    end
    context 'with identifiers params' do
      it 'returns job id' do
        get(api_v1_path('Contacts'),
          { :identifiers => [1]},
          'HTTP_AUTHENTICATION' => "Token #{token}"
        )

        expect(json['results']['job_id']).to eq Job.first.id
      end
      it 'creates a ReadJob' do
        expect{
          get(api_v1_path('Contacts'),
            { :identifiers => [1]},
            'HTTP_AUTHENTICATION' => "Token #{token}"
          )
        }.to change{
          ReadJob.count
        }.by 1
      end
      it 'returns accepted status (202)' do
        rsp = get(api_v1_path('Contacts'),
          { :identifiers => [1]},
          'HTTP_AUTHENTICATION' => "Token #{token}"
        )

        expect(rsp).to eq 202
      end
    end
    context 'with search_by params' do
      it 'returns job id' do
        get(api_v1_path('Contacts'),
          { search_by: {email: 'some_user@email.com' }},
          'HTTP_AUTHENTICATION' => "Token #{token}"
        )

        expect(json['results']['job_id']).to eq Job.first.id
      end
      it 'creates a ReadJob' do
        expect{
          get(api_v1_path('Contacts'),
            { search_by: {email: 'some_user@email.com' }},
            'HTTP_AUTHENTICATION' => "Token #{token}"
          )
        }.to change{
          SearchJob.count
        }.by 1
      end
      it 'returns accepted status (202)' do
        rsp = get(api_v1_path('Contacts'),
          { search_by: {email: 'slevin@kelevra.com' }},
          'HTTP_AUTHENTICATION' => "Token #{token}"
        )

        expect(rsp).to eq 202
      end
    end
    context 'when unauthorized' do
      it 'returns unauthorized status (401)' do
        expect(get(api_v1_path('Contacts'),
          'HTTP_AUTHORIZATION' => "Token bad_token"
        )).to eq 401
      end
    end
    context 'when missing params' do
      it 'returns bad_request status (400)' do
        expect(get(api_v1_path('Contacts'),
          nil,
          'HTTP_AUTHENTICATION' => "Token #{token}"
        )).to eq 400
      end
      it 'returns missing param message' do
        get(api_v1_path('Contacts'),
          nil,
          'HTTP_AUTHENTICATION' => "Token #{token}"
        )

        expect(json['message']).to eq(
          %q(Get Requests Params must include either created_since, updated_since, identifiers, or search_by.)
        )
      end
    end
    context 'when given bad params' do
      it 'returns bad_request status (400)' do
        expect(get(api_v1_path('Contacts'),
          { :created_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%F %T') },
          'HTTP_AUTHENTICATION' => "Token #{token}"
        )).to eq 400
      end
      it 'returns missing param message' do
        get(api_v1_path('Contacts'),
          { :updated_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%F %T') },
          'HTTP_AUTHENTICATION' => "Token #{token}"
        )

        expect(json['message']).to eq(
          "updated_since requires format \"YYYY-mm-ddTHH:MM:SS-Z\""
        )
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
            name: 'first_name'
          }]
        }]
      )
    end
    it 'returns unprocessable_entity status (422)' do
      rsp = get(api_v1_path('Contacts'),
        { :created_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%FT%T%z') },
        'HTTP_AUTHENTICATION' => "Token #{token}"
      )

      expect(rsp).to eq 422
    end
    it 'returns unsupported action message' do
      get(api_v1_path('Contacts'),
        { :created_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%FT%T%z') },
        'HTTP_AUTHENTICATION' => "Token #{token}"
      )

      expect(json['message']).to eq(
        "Can not request created for Development RemoteApi's Contacts."
      )
    end
  end
end
