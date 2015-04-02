require 'rails_helper'

describe 'Describe' do
  it 'lists versions' do
      get(root_path, nil, 'HTTP_ACCEPT' => 'application/json')

      expect(json['versions']).to include(
        'url' => '/v1',
        'label' => '1.0'
      )
  end
end
