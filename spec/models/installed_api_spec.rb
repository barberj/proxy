require 'rails_helper'

describe InstalledApi do
  describe '.create' do
    context 'before' do
      it 'generates local_token' do
        installed = InstalledApi.create(
          name: 'InstalledRemoteApi',
          account_id: 1,
          api_id: 1
        )
        expect(installed.local_token).to be_present
      end
      it 'generates remote_token' do
        installed = InstalledApi.create(
          name: 'InstalledRemoteApi',
          account_id: 1,
          api_id: 1
        )
        expect(installed.remote_token).to be_present
      end
      it 'defaults name' do
        api = create_api
        new_account = create(:account)
        installed = new_account.installed_apis.create(
          api: api
        )

        expect(installed.name).to eq("My RemoteApi")
      end
    end
  end
end
