require 'rails_helper'

describe 'UsersController' do

  context 'post' do
    let(:create_requst) do
      post('/users', {
          'first_name' => 'John',
          'last_name'  => 'Doe',
          'email'      => 'john.doe@gmail.com',
          'password'   => 'letmein'
      }, nil)
    end
    it 'creates a user' do
      expect{
        create_requst
      }.to change{
        User.count
      }.by(1)
    end
    it 'returns created http status' do
      rsp = create_requst
      expect(rsp).to eq 201
    end
  end
end
