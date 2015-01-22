require 'rails_helper'

describe Account do
  let(:new_account) { create(:account) }

  describe '#internal?' do
    it 'returns true for first account' do
      expect(Account.first.internal?).to be_truthy
    end
    it 'returns false for any account after first' do
      expect(create(:account).internal?).to be_falsy
    end
  end
  describe '#install_api' do
    def api_installation
      new_account.install_api(Api.first)
    end
    it 'creates data encoding' do
      expect{
        api_installation
      }.to change{
        new_account.data_encodings.count
      }.by 1
    end
    it 'creates default data encoding' do
      expect{
        api_installation
      }.to change{
        new_account.data_encoding_templates.count
      }.by 1
    end
    it 'uses default data encoding' do
      api_installation

      default = new_account.data_encoding_templates.first
      enc_attrs = default.encoded_attributes
      enc_attrs.first['name'] = 'MyContacts'
      default.encoded_attributes = enc_attrs
      default.save

      de = api_installation
      expect(de.encoded_resources.find_by(name: 'MyContacts')).to be_present
    end
  end
end
