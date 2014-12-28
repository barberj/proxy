require 'rails_helper'

describe 'UsersController' do

  context 'post' do
    let(:user_data) do
      {
        'first_name' => 'John',
        'last_name'  => 'Doe',
        'email'      => 'john.doe@gmail.com',
        'password'   => 'letmein'
      }
    end
    let(:create_request) do
      post('/users', user_data, nil)
    end
    it 'creates a user' do
      expect{
        create_request
      }.to change{
        User.count
      }.by(1)
    end
    context 'valid params' do
      it 'returns created' do
        rsp = create_request
        expect(rsp).to eq 201
      end
    end
    context 'invalid params' do
      it 'returns bad_request with duplicate email' do
        User.create(user_data.merge(:account_id => Account.create.id))
        user_data['email'] = user_data['email'].upcase
        rsp = create_request
        expect(rsp).to eq 400
      end
      it 'returns bad_request with invalid email' do
        user_data['email'] = 'e'
        rsp = create_request
        expect(rsp).to eq 400
      end
    end
  end
end
