class Api::V1::ApisController < ActionController::Base
  def index
    render json: { apis: Api.all.map{|api| api.to_builder.attributes! } }
  end
end
