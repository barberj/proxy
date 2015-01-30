require 'rails_helper'

describe 'Users' do

  context 'post' do
    let(:user_data) do
      {
        'first_name' => 'John',
        'last_name'  => 'Doe',
        'email'      => 'john.doe@gmail.com',
        'password'   => 'letmein',
      }
    end
    let(:create_request) do
      post(v1_users_path, user_data, nil)
    end
    context 'with valid params' do
      it 'creates a user' do
        expect{
          create_request
        }.to change{
          User.count
        }.by(1)
      end
      it 'returns created (201) status code' do
        rsp = create_request
        expect(rsp).to eq 201
      end
    end
    context 'with invalid' do
      it 'duplicate email returns bad_request (400) status code' do
        User.create(
          user_data.except('credit_card').
            merge(:account_id => Account.create.id)
        )
        user_data['email'] = user_data['email'].upcase
        rsp = create_request
        expect(rsp).to eq 400
      end
      it 'email returns bad_request (400) status code' do
        user_data['email'] = 'e'
        rsp = create_request
        expect(rsp).to eq 400
      end
    end
  end
end
