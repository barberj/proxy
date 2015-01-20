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
    let(:job_data) { { job_id: job.id } }
    context 'with valid job id' do
      let(:get_job_request) do
        get(v1_jobs_path, job_data,
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )
      end
      it 'returns ok status (200)' do
        expect(get_job_request).to eq 200
      end
      it 'returns serialized job info' do
        get_job_request
        puts
      end
    end
    context 'with invalid job id' do
      let(:get_job_request) do
        get(v1_jobs_path, { job_id: 999 },
          'HTTP_AUTHORIZATION' => "Token #{user_token}"
        )
      end
      it 'returns bad_request status (400)' do
        expect(get_job_request).to eq 400
      end
      it 'returns invalid job id message' do
        get_job_request
        expect(json['message']).to eq(
          'Please provide a valid job_id.'
        )
      end
    end
    context 'for external user' do
      context 'with invalid job id' do
        let(:get_anothers_job_request) do
          get(v1_jobs_path, job_data,
            'HTTP_AUTHORIZATION' => "Token #{external_user_token}"
          )
        end
        it 'returns bad_request status (400)' do
          expect(get_anothers_job_request).to eq 400
        end
        it 'returns invalid job id message' do
          get_anothers_job_request
          expect(json['message']).to eq(
            'Please provide a valid job_id.'
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
          get(v1_jobs_path, job_data,
            'HTTP_AUTHORIZATION' => "Token #{external_user_token}"
          )
        end
        it 'returns ok status (200)' do
          expect(get_job_request).to eq 200
        end
        it 'returns serialized job info' do
          get_job_request

          expect(json['results']).to eq(
            [{'first_name' => 'Justin'}]
          )
        end
      end
    end
  end
end
