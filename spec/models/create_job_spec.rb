require 'rails_helper'

describe CreateJob do
  let(:default_job) do
    default_data_encoding.jobs.create(
      type: 'CreateJob',
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
      type: 'CreateJob',
      resource_id: custom_encoded_resource.resource_id,
      encoded_resource_id: custom_encoded_resource.id,
      account_id: account.id,
      params: {
        data: [{ 'fname' => 'Justin' }]
      }
    )
  end
  let(:stub_resource_request) do
    stub_request(:post, 'https://remoteapi.com/create')
      .with(
        :headers => {
          'Authorization' => "Token #{remote_token}",
          'content-type' => 'application/json'
        },
        :body => {
          data: [{ 'fname' => 'Justin' }]
        }.to_json
      ).to_return(File.new("spec/webmocks/installed_apis/insightly/a_contact.txt"))
  end
end
