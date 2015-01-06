class Api::V1::ResourcesController < ActionController::Base
  def index
    render json: { resources: Resource.all.map{|resource| resource.to_builder.attributes! } }
  end

  def show
    render json: { resource: resource.to_builder.attributes! }
  end

  private

  def resource
    resource.find(params[:id])
  end
end
