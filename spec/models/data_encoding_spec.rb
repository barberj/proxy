require 'rails_helper'

describe DataEncoding do
  describe '.create' do
    context 'before' do
      it 'generates token' do
        expect(DataEncoding.create(
          name: 'My RemoteApi Encoding',
          installed_api_id: 1,
          account_id: 1
        ).token).to be_present
      end
    end
  end
end
