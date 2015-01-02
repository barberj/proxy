module Helpers
  module Common
    extend ActiveSupport::Concern

    included do
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
              name: 'first_name'
            }]
          }]
        )
      end
      let(:installed_api) do
        create_api
        account.installed_apis.first
      end
      let(:default_data_encoding) do
        installed_api.data_encodings.first
      end
      let(:token_for_default) do
        default_data_encoding.token
      end
      let(:remote_token) do
        installed_api.token
      end
      let(:custom_data_encoding) do
        installed_api.data_encodings.create(
          name: 'Custom Encoding',
          account_id: account.id,
          encoded_resources_attributes: [{
            name: 'MyContacts',
            resource_id: installed_api.api.resources.first.id,
            encoded_fields_attributes: [{
              name: 'fname',
              field_id: installed_api.api.resources.first.fields.first.id
            }]
          }]
        )
      end
      let(:token_for_custom) do
        custom_data_encoding.token
      end
    end
  end

  module Request
    def json
      @json ||= JSON.parse(response.body)
    end
  end
end
