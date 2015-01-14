require 'rails_helper'

describe UpdateJob do
  let(:default_job) do
    default_data_encoding.jobs.create(
      type: 'UpdateJob',
      resource_id: default_encoded_resource.resource_id,
      encoded_resource_id: default_encoded_resource.id,
      account_id: account.id,
      params: {
        data: [{ 'FIRST_NAME' => 'Justin' }]
      }
    )
  end
  let(:custom_job) do
    custom_data_encoding.jobs.create(
      type: 'UpdateJob',
      resource_id: custom_encoded_resource.resource_id,
      encoded_resource_id: custom_encoded_resource.id,
      account_id: account.id,
      params: {
        data: [{ 'fname' => 'Justin' }]
      }
    )
  end
  let(:stub_resource_request) do
    stub_request(:put, 'https://remoteapi.com/update')
      .with(
        :headers => {
          'Authorization' => "Token #{@remote_token}",
          'content-type' => 'application/json'
        },
        :body => {
          data: [{ 'FIRST_NAME' => 'Justin' }]
        }.to_json
      ).to_return(File.new("spec/webmocks/installed_apis/insightly/a_contact.txt"))
  end

  describe '#process' do
    it 'requests update' do
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
    it 'decodes data, encodes results' do
      @remote_token = custom_remote_token
      stub_resource_request
      custom_job.process
      results = custom_job.results['results']
      contact = results.first

      expect(contact['fname']).to eq 'Justin'
    end
  end
end
