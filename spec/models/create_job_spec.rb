require 'rails_helper'

describe CreateJob do
  let(:default_job) do
    default_data_encoding.jobs.create(
      type: 'CreateJob',
      resource_id: default_encoded_resource.resource_id,
      encoded_resource_id: default_encoded_resource.id,
      account_id: account.id,
      params: {
        data: [{
          'FIRST_NAME'     => 'Coty',
          'WORK_EMAILS'    => ['coty@ecommhub.com'],
          'WORK_ADDRESSES' => [{
            'STREET' => '123 Street'
          }]
        }]
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
        data: [{
          'fname'         => ['Coty'],
          'email_address' => 'coty@ecommhub.com',
          'WORK_ADDRESSES' => {
            'STREET' => '123 Street'
          }
        }]
      }
    )
  end
  let(:custom_two_job) do
    api = default_data_encoding.api
    custom_encoding = account.data_encodings.create(
      api_id: api.id,
      name: 'Custom Encoding Two',
      encoded_resources_attributes: [{
        name: 'MyContacts',
        resource_id: api.resources.first.id,
        encoded_fields_attributes: [{
          dpath: '/fname/*',
          field_id: api.resources.first.fields.first.id
        },{
          dpath: '/email_address/*',
          field_id: api.resources.first.fields[1].id
        },{
          dpath: '/street/*',
          field_id: api.resources.first.fields[2].id
        }]
      }]
    )
    @remote_token = custom_encoding.token
    stub_resource_request
    custom_encoding.jobs.create(
      type: 'CreateJob',
      resource_id: custom_encoding.encoded_resources.first.resource_id,
      encoded_resource_id: custom_encoding.encoded_resources.first.id,
      account_id: account.id,
      params: {
        data: [{
          'fname'         => 'Coty',
          'email_address' => 'coty@ecommhub.com',
          'street'        => '123 Street'
        }]
      }
    )
  end
  let(:stub_resource_request) do
    stub_request(:post, 'https://remoteapi.com/create')
      .with(
        :headers => {
          'Authorization' => "Token #{@remote_token}",
          'content-type' => 'application/json'
        },
        :body => {
          data: [{
            'FIRST_NAME'  => 'Coty',
            'WORK_EMAILS' => ['coty@ecommhub.com'],
            'WORK_ADDRESSES' => [{
              'STREET' => '123 Street'
            }]
          }]
        }.to_json
      ).to_return(File.new("spec/webmocks/installed_apis/insightly/a_contact.txt"))
  end

  describe '#process' do
    it 'requests create' do
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

      expect(contact['fname']).to eq ['Coty']
      expect(contact['email_address']).to eq 'coty@ecommhub.com'
      expect(contact['WORK_ADDRESSES']['STREET']).to eq '730 Peachtree St NE #330'
    end
    it 'decodes data, encodes results' do
      custom_two_job.process
      results = custom_two_job.results['results']
      contact = results.first

      expect(contact['fname']).to eq 'Coty'
      expect(contact['email_address']).to eq 'coty@ecommhub.com'
      expect(contact['street']).to eq '730 Peachtree St NE #330'
    end
    it 'handles collection nested fields' do
      stub_request(:post, 'https://remoteapi.com/create')
        .with(
          :headers => {
            'Authorization' => "Token #{@remote_token}",
            'content-type' => 'application/json'
          },
          :body => {
            data: [{
              'FIRST_NAME'  => 'Coty',
              'WORK_EMAILS' => ['coty@ecommhub.com'],
              'WORK_ADDRESSES' => [{
                'STREET' => '123 Street',
              },{
                'STREET' => '234 Street',
              }]
            }]
          }.to_json
        ).to_return(File.new("spec/webmocks/installed_apis/insightly/a_contact.txt"))

      job = default_data_encoding.jobs.create(
        type: 'CreateJob',
        resource_id: default_encoded_resource.resource_id,
        encoded_resource_id: default_encoded_resource.id,
        account_id: account.id,
        params: {
          data: [{
            'FIRST_NAME'     => 'Coty',
            'WORK_EMAILS'    => ['coty@ecommhub.com'],
            'WORK_ADDRESSES' => [{
              'STREET' => '123 Street',
            },{
              'STREET' => '234 Street',
            }]
          }]
        }
      )

      job.process
    end
  end
end
