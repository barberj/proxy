require 'rails_helper'

describe CreatedJob do
  let(:default_job) do
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
  let(:custom_job) do
    custom_data_encoding.jobs.create(
      type: 'CreatedJob',
      resource_id: custom_encoded_resource.resource_id,
      encoded_resource_id: custom_encoded_resource.id,
      account_id: account.id,
      params: {
        created_since: '2015-01-01T22:00:00+0000',
        page: 2,
        limit: 50
      }
    )
  end
  let(:stub_resource_request) do
    stub_request(:get, 'https://remoteapi.com/created')
      .with(
        :headers => { 'Authorization' => "Token #{@remote_token}" },
        :query   => {
          created_since: '2015-01-01T22:00:00+0000',
          page: 2,
          limit: 50
        }
      ).to_return(File.new("spec/webmocks/installed_apis/insightly/a_contact.txt"))
  end

  describe '#process' do
    it 'requests created' do
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
        type: 'CreatedJob',
        resource_id: default_encoded_resource.resource_id,
        encoded_resource_id: default_encoded_resource.id,
        account_id: account.id,
        params: {
          created_since: '2015-01-01T22:00:00+0000',
          limit: 50
        }
      )

      stub = stub_request(:get, 'https://remoteapi.com/created')
        .with(
          :headers => { 'Authorization' => "Token #{@remote_token}" },
          :query   => {
            created_since: '2015-01-01T22:00:00+0000',
            page: 1,
            limit: 50
          }
        ).to_return(File.new("spec/webmocks/installed_apis/insightly/a_contact.txt"))

      job.process
      expect(stub).to have_been_requested
    end
    it 'defaults limit' do
      job = default_data_encoding.jobs.create(
        type: 'CreatedJob',
        resource_id: default_encoded_resource.resource_id,
        encoded_resource_id: default_encoded_resource.id,
        account_id: account.id,
        params: {
          created_since: '2015-01-01T22:00:00+0000',
          page: 2
        }
      )

      stub = stub_request(:get, 'https://remoteapi.com/created')
        .with(
          :headers => { 'Authorization' => "Token #{@remote_token}" },
          :query   => {
            created_since: '2015-01-01T22:00:00+0000',
            page: 2,
            limit: 250
          }
        ).to_return(File.new("spec/webmocks/installed_apis/insightly/a_contact.txt"))

      job.process
      expect(stub).to have_been_requested
    end
    it 'uses max limit' do
      job = default_data_encoding.jobs.create(
        type: 'CreatedJob',
        resource_id: default_encoded_resource.resource_id,
        encoded_resource_id: default_encoded_resource.id,
        account_id: account.id,
        params: {
          created_since: '2015-01-01T22:00:00+0000',
          page: 2,
          limit: 251
        }
      )

      stub = stub_request(:get, 'https://remoteapi.com/created')
        .with(
          :headers => { 'Authorization' => "Token #{@remote_token}" },
          :query   => {
            created_since: '2015-01-01T22:00:00+0000',
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

      expect(contact['fname']).to eq 'Coty'
      expect(contact['email_address']).to eq 'coty@ecommhub.com'
    end
    it 'encodes default data' do
      stub_resource_request
      default_job.process
      results = default_job.results['results']
      contact = results.first

      expect(contact['FIRST_NAME']).to eq 'Coty'
      expect(contact['WORK_EMAILS'].first).to include( 'coty@ecommhub.com' )
      expect(contact['WORK_ADDRESSES'].first).to include(
        'STREET' => "730 Peachtree St NE #330",
        'CITY'   => 'Atlanta'
      )
    end
  end
end
