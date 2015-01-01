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
      let(:token) do
        account.installed_apis.first.data_encodings.first.token
      end
    end
  end

  module Request
    def json
      @json ||= JSON.parse(response.body)
    end
  end
end
