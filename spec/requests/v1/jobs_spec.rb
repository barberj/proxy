require 'rails_helper'

describe 'Jobs' do
  context 'get request' do
    let(:job) do
      default_data_encoding.jobs.create(
        type: 'CreatedJob',
        resource_id: default_encoded_resource.resource_id,
        encoded_resource_id: default_encoded_resource.id,
        account_id: account.id,
        params: {
          created_since: '2015-01-01T22:00:00+0000',
          page: 2,
          limit: 50
        }
      )
    end
    context 'with valid job id' do
      let(:get_job_request) do
        get(v1_job_path(job.id), nil,
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )
      end
      it 'returns ok status (200)' do
        expect(get_job_request).to eq 200
      end
      it 'returns serialized job info' do
        get_job_request
      end
    end
    context 'with invalid job id' do
      let(:get_job_request) do
        get(v1_job_path(999), nil,
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )
      end
      it 'returns bad_request status (400)' do
        expect(get_job_request).to eq 400
      end
      it 'returns invalid job id message' do
        get_job_request
        expect(json['message']).to eq(
          'Please provide a valid id.'
        )
      end
    end
    context 'for external user' do
      context 'with invalid job id' do
        let(:get_anothers_job_request) do
          get(v1_job_path(job.id), nil,
            'HTTP_AUTHORIZATION' => "Token #{external_user_token}"
          )
        end
        it 'returns bad_request status (400)' do
          expect(get_anothers_job_request).to eq 400
        end
        it 'returns invalid job id message' do
          get_anothers_job_request
          expect(json['message']).to eq(
            'Please provide a valid id.'
          )
        end
      end
      context 'with valid job id' do
        let(:job) do
          external_data_encoding.jobs.create(
            type: 'CreatedJob',
            resource_id: external_encoded_resource.resource_id,
            encoded_resource_id: external_encoded_resource.id,
            account_id: external_account.id,
            params: {
              created_since: '2015-01-01T22:00:00+0000',
              page: 2,
              limit: 50
            },
            results: { results: [{first_name: 'Justin'}]}
          )
        end
        let(:get_job_request) do
          get(v1_job_path(job.id), nil,
            'HTTP_AUTHORIZATION' => "Token #{external_user_token}"
          )
        end
        it 'returns ok status (200)' do
          expect(get_job_request).to eq 200
        end
        it 'returns serialized job info' do
          job.status = 'processed'
          job.save

          get_job_request

          expect(json['results']).to eq(
            [{'first_name' => 'Justin'}]
          )

          expect(json['status']).to eq(
            'processed'
          )
        end
        it 'does not returns serialized job info before its processed' do
          get_job_request

          expect(json['status']).to eq(
            'queued'
          )
        end
        it 'returns params' do
          get_job_request

          expect(json['params']).to be_present
        end
        it 'does not returns params for SetJob' do
          job.type = 'UpdateJob'
          job.save

          get_job_request

          expect(json['params']).not_to be_present
        end
      end
    end
  end
end
