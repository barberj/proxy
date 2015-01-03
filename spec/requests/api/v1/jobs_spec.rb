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
    let(:job_data) do
      {
        job_id: job.id
      }
    end
    context 'with valid job id' do
      it 'returns serialized job info' do
        get(api_v1_jobs_path, job_data,
          'HTTP_AUTHENTICATION' => "Token #{user_token}"
        )
      end
    end
  end
end
