require 'rails_helper'

describe 'GetRequests' do
  context 'for InstalledApi with action' do
    before { create_api }
    context 'with created_since params' do
      it 'returns job id' do
        get(api_v1_path('Contacts'),
          { :created_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%FT%T%z') },
          'HTTP_AUTHENTICATION' => "Token #{local_token}"
        )

        binding.pry
        expect(json['results']['job_id']).to eq 1
      end
      it 'returns accepted status (202)' do
        rsp = get(api_v1_path('Contacts'),
          { :created_since => Time.new(2014, 12, 29, 0, 0, 0, 0).strftime('%FT%T%z') },
          'HTTP_AUTHENTICATION' => "Token #{local_token}"
        )

        expect(rsp).to eq 202
      end
    end
    context 'with updated_since params' do
      it 'returns job id'
      it 'returns accepted status (202)'
    end
    context 'with identifiers params' do
      it 'returns job id'
      it 'returns accepted status (202)'
    end
    context 'with search_by params' do
      it 'returns job id'
      it 'returns accepted status (202)'
    end
    context 'when unauthorized' do
      it 'returns unauthorized status (401)' do
        expect(get(api_v1_path('Contacts'),
          'HTTP_AUTHORIZATION' => "Token bad_token"
        )).to eq 401
      end
    end
    context 'when missing params'
    context 'when given bad params'
  end
  context 'for InstalledApi without action' do
  end
end
