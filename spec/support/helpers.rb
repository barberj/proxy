module Helpers
  module Common
    extend ActiveSupport::Concern

    included do
      before { @remote_token = default_remote_token }
      let(:account) { create(:account) }

      let(:create_api) do
        account.apis.create(
          name: 'RemoteApi',
          install_url: 'https://remoteapi.com/install',
          uninstall_url: 'https://remoteapi.com/uninstall',
          resources_attributes: [{
            name: 'Contacts',
            customs_url: 'https://remoteapi.com/customs',
            search_url: 'https://remoteapi.com/search',
            created_url: 'https://remoteapi.com/created',
            updated_url: 'https://remoteapi.com/updated',
            create_url: 'https://remoteapi.com/create',
            update_url: 'https://remoteapi.com/update',
            delete_url: 'https://remoteapi.com/delete',
            read_url: 'https://remoteapi.com/read',
            fields_attributes: [{
              dpath: '/FIRST_NAME'
            },{
              dpath: '/WORK_EMAILS/[]'
            },{
              dpath: '/WORK_ADDRESSES//STREET'
            },{
              dpath: '/WORK_ADDRESSES//CITY'
            },{
              dpath: '/OTHER_ADDRESSES//STREET'
            }]
          }]
        )
      end
      let(:user) do
        account.users.first
      end
      let(:default_data_encoding) do
        account.install_api(create_api)
      end
      let(:user_token) do
        user.token
      end
      let(:default_encoded_resource) do
        default_data_encoding.encoded_resources.first
      end
      let(:default_remote_token) do
        default_data_encoding.token
      end
      let(:custom_data_encoding) do
        api = default_data_encoding.api
        account.data_encodings.create(
          api_id: api.id,
          name: 'Custom Encoding',
          encoded_resources_attributes: [{
            name: 'MyContacts',
            resource_id: api.resources.first.id,
            encoded_fields_attributes: [{
              dpath: '/fname',
              field_id: api.resources.first.fields.first.id
            },{
              dpath: '/email_address/0',
              field_id: api.resources.first.fields[1].id
            }]
          }]
        )
      end
      let(:custom_remote_token) do
        custom_data_encoding.token
      end
      let(:custom_encoded_resource) do
        custom_data_encoding.encoded_resources.first
      end

      let(:external_account) { create(:account) }
      let(:external_user) do
        external_account.users.first
      end
      let(:external_user_token) do
        external_user.token
      end
      let(:external_data_encoding) do
        external_account.install_api(create_api)
      end
      let(:external_encoded_resource) do
        external_data_encoding.encoded_resources.first
      end
    end
  end

  module Request
    def json
      @json ||= JSON.parse(response.body)
    end
  end
end
