class DescribeController < ActionController::Base
  respond_to :json

  def show
    @versions = [{
      :url => '/v1',
      :label => '1.0'
    }]

    respond_with(@versions, status: 200)
  end
end
