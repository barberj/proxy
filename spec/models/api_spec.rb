require 'rails_helper'

describe Api do

  context '.create' do
    it 'creates an Api with resources and fields' do
      account = create(:account)
      expect{
        account.apis.create(
          name: 'insightly',
          install_url: 'https://remoteapi.com/install',
          uninstall_url: 'https://remoteapi.com/uninstall'
        )
      }.to change {
        account.apis.count
      }.by 1
    end
    it 'creates an Api with resources and fields' do
      account = create(:account)
      expect{
        account.apis.create(
          name: 'insightly',
          install_url: 'https://remoteapi.com/install',
          uninstall_url: 'https://remoteapi.com/uninstall',
          resources_attributes: [{
            name: 'Contacts',
            fields_attributes: [{
              name: 'first_name'
            }]
          }]
        )
      }.to change {
        Resource.count
      }.by 1
    end
  end
end
