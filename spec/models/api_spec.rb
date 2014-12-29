require 'rails_helper'

describe Api do
  context '.create' do
    it 'creates an Api with resources and fields' do
      expect{
        account.apis.create(
          name: 'RemoteApi',
          install_url: 'https://remoteapi.com/install',
          uninstall_url: 'https://remoteapi.com/uninstall'
        )
      }.to change {
        account.apis.count
      }.by 1
    end
    it 'creates an Api with resources' do
      expect{
        account.apis.create(
          name: 'RemoteApi',
          install_url: 'https://remoteapi.com/install',
          uninstall_url: 'https://remoteapi.com/uninstall',
          resources_attributes: [{
            name: 'Contacts'
          }]
        )
      }.to change {
        Resource.count
      }.by 1
    end
    it 'creates an Api with fields' do
      expect{
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
      }.to change {
        Field.count
      }.by 1
    end
    context 'after' do
      context "installs dev api" do
        it "on owner's account" do
          expect{ create_api }.to change {
            account.installed_apis.count
          }.by 1
        end
        it '#is_dev is true' do
          create_api
          expect(account.installed_apis.first.is_dev).to be_truthy
        end
        it "with name prefixed by 'Development'" do
          create_api
          expect(account.installed_apis.first.name).to eq "Development RemoteApi"
        end
      end
    end
  end
end
