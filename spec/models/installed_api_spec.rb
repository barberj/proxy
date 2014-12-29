require 'rails_helper'

describe InstalledApi do
  describe '.create' do
    it 'generates token' do
      installed = InstalledApi.create(
        name: 'InstalledRemoteApi',
        account_id: 1,
        api_id: 1
      )
      expect(installed.token).to be_present
    end
  end
end
