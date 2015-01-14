require 'rails_helper'

describe ReadJob do
  let(:default_job) do
    default_data_encoding.jobs.create(
      type: 'ReadJob',
      resource_id: default_encoded_resource.resource_id,
      encoded_resource_id: default_encoded_resource.id,
      account_id: account.id,
      params: {
        identifiers: [1],
        page: 2,
        limit: 50
      }
    )
  end
  let(:custom_job) do
    custom_data_encoding.jobs.create(
      type: 'ReadJob',
      resource_id: custom_encoded_resource.resource_id,
      encoded_resource_id: custom_encoded_resource.id,
      account_id: account.id,
      params: {
        identifiers: [1],
        page: 2,
        limit: 50
      }
    )
  end
  let(:stub_resource_request) do
    stub_request(:get, 'https://remoteapi.com/read')
      .with(
        :headers => { 'Authorization' => "Token #{@remote_token}" },
        :query   => {
          identifiers: [1],
          page: 2,
          limit: 50
        }
      ).to_return(File.new("spec/webmocks/installed_apis/insightly/a_contact.txt"))
  end

  describe '#process' do
    it 'requests identifiers' do
      stub = stub_resource_request
      default_job.process
      expect(stub).to have_been_requested
    end
    it 'saves results to job' do
      stub_resource_request

      expect{
        default_job.process
      }.to change{
        default_job.results
      }.to be_present
    end
    it 'defaults page' do
      job = default_data_encoding.jobs.create(
        type: 'ReadJob',
        resource_id: default_encoded_resource.resource_id,
        encoded_resource_id: default_encoded_resource.id,
        account_id: account.id,
        params: {
          identifiers: [1],
          limit: 50
        }
      )

      stub = stub_request(:get, 'https://remoteapi.com/read')
        .with(
          :headers => { 'Authorization' => "Token #{@remote_token}" },
          :query   => {
            identifiers: [1],
            page: 1,
            limit: 50
          }
        ).to_return(File.new("spec/webmocks/installed_apis/insightly/a_contact.txt"))

      job.process
      expect(stub).to have_been_requested
    end
    it 'defaults limit' do
      job = default_data_encoding.jobs.create(
        type: 'ReadJob',
        resource_id: default_encoded_resource.resource_id,
        encoded_resource_id: default_encoded_resource.id,
        account_id: account.id,
        params: {
          identifiers: [1],
          page: 2
        }
      )

      stub = stub_request(:get, 'https://remoteapi.com/read')
        .with(
          :headers => { 'Authorization' => "Token #{@remote_token}" },
          :query   => {
            identifiers: [1],
            page: 2,
            limit: 250
          }
        ).to_return(File.new("spec/webmocks/installed_apis/insightly/a_contact.txt"))

      job.process
      expect(stub).to have_been_requested
    end
    it 'uses max limit' do
      job = default_data_encoding.jobs.create(
        type: 'ReadJob',
        resource_id: default_encoded_resource.resource_id,
        encoded_resource_id: default_encoded_resource.id,
        account_id: account.id,
        params: {
          identifiers: [1],
          page: 2,
          limit: 251
        }
      )

      stub = stub_request(:get, 'https://remoteapi.com/read')
        .with(
          :headers => { 'Authorization' => "Token #{@remote_token}" },
          :query   => {
            identifiers: [1],
            page: 2,
            limit: 250
          }
        ).to_return(File.new("spec/webmocks/installed_apis/insightly/a_contact.txt"))

      job.process
      expect(stub).to have_been_requested
    end
    it 'encodes data' do
      @remote_token = custom_remote_token
      stub_resource_request
      custom_job.process
      results = custom_job.results['results']
      contact = results.first

      expect(contact['fname']).to eq 'Justin'
    end
  end
end
