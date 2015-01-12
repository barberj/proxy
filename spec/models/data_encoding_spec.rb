require 'rails_helper'

describe DataEncoding do
  describe '#as_json' do
    it 'returns attributes' do
      expect(custom_data_encoding.as_json).
        to include( 'name' => 'Custom Encoding' )
    end
    it 'returns nested encoded_resources' do
      expect(
        custom_data_encoding.as_json['encoded_resources_attributes'].
        first
      ).
        to include( 'name' => 'MyContacts' )
    end
    it 'returns nested encoded_fields' do
      expect(
        custom_data_encoding.
          as_json['encoded_resources_attributes'].
          first['encoded_fields_attributes'].
          first
      ).
        to include( 'dpath' => '/fname/*' )
    end
  end
end
