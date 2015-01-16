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
              dpath: '/first_name'
            }]
          }]
        )
      }.to change {
        Field.count
      }.by 1
    end
    context 'after' do
      context "creates default data encoding" do
        it "on owner's account" do
          expect(account.data_encodings.count).to eq 1
        end
        it "with encoded resource name matching api resource" do
          encoded_resource = account.data_encodings.first.encoded_resources.first

          expect(encoded_resource.name).to be_present
          expect(encoded_resource.name).to eq encoded_resource.resource.name
        end
        it "with encoded fields dpath matching api fields" do
          encoded_resource = account.data_encodings.first.encoded_resources.first
          encoded_field = encoded_resource.encoded_fields.first

          expect(encoded_field.dpath).to be_present
          expect(encoded_field.dpath).to eq encoded_field.field.dpath
        end
      end
    end
  end
end
