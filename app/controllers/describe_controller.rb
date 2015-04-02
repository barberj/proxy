class DescribeController < ActionController::Base
  def show
    @versions = [{
      :url => '/v1',
      :label => '1.0'
    }]

    render json: { versions: @versions }, status: 200
  end
end
