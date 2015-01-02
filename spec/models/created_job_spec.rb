require 'rails_helper'

describe CreatedJob do
  let(:job) do
    data_encoding.jobs.create(
      type: 'CreatedJob',
      resource_id: data_encoding.encoded_resources.first.id,
      params: {
        created_since: '2015-01-01T22:00:00+0000'
      }
    )
  end
  context '#process' do
    let(:stub_resource_request) do
      stub_request(:get, 'https://remoteapi.com/created')
        .with(
          :headers => { 'Authorization' => "Token #{remote_token}" },
          :query   => {
            created_since: '2015-01-01T22:00:00+0000',
            page: 1,
            limit: 250
          }
        ).to_return(File.new("spec/webmocks/installed_apis/insightly/a_contact.txt"))
    end
    it 'requests created' do
      stub = stub_resource_request
      job.process
      expect(stub).to have_been_requested
    end
    it 'saves results to job' do
      stub_resource_request

      expect{
        job.process
      }.to change{
        job.results
      }.to be_present
    end
    it 'encodes data' do
    end
  end
end
