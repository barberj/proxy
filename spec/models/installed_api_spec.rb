require 'rails_helper'

describe InstalledApi do
  describe '.create' do
    context 'before' do
      it 'generates token' do
        expect_any_instance_of(InstalledApi)
          .to receive(:create_default_data_encoding)

        expect(InstalledApi.create(
          name: 'InstalledRemoteApi',
          account_id: 1,
          api_id: 1
        ).token).to be_present
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
