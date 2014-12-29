module Helpers
  module Common
    extend ActiveSupport::Concern
    included do
      let(:account) { create(:account) }
    end
  end

  module Request
    def json
      @json ||= JSON.parse(response.body)
    end
  end
end
