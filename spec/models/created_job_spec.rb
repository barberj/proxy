require 'rails_helper'

describe CreatedJob do
  let(:job) do
    data_encoding.jobs.create(
      type: 'CreatedJob',
      criteria: {
        resource: 'Contacts',
        created_since: '2015-01-01T22:00:00+0000'
      }
    )
  end
  it '#process' do
    binding.pry
    puts
  end
end
