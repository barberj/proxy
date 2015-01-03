require 'rails_helper'

describe User do
  describe '.create' do
    context 'before' do
      it 'generates token' do
        expect(User.create(
          first_name: 'John',
          last_name: 'Doe',
          email: 'john.doe@example.com',
          password: 'password',
          account_id: 1
        ).token).to be_present
      end
    end
  end
end
