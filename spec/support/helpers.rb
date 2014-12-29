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
            fields_attributes: [{
              name: 'first_name'
            }]
          }]
        )
      end
    end
  end

  module Request
    def json
      @json ||= JSON.parse(response.body)
    end
  end
end
