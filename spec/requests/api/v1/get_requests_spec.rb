require 'rails_helper'

describe 'GetRequests' do
  context 'for InstalledApi with action' do
    before { create_api }
    context 'with created_since params' do
      it 'returns job id'
      it 'returns accepted status (202)'
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
    context 'when unauthorized'
    context 'when missing params'
    context 'when given bad params'
  end
  context 'for InstalledApi without action' do
  end
end
