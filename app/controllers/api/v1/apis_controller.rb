class Api::V1::ApisController < Api::V1::InternalApiController

  def index
    render json: { apis: all_apis }, status: :ok
  end

  def create
    binding.pry
    puts
  end

private

  def all_apis
    if account.internal?
      Api.all
    else
      account.apis
    end
  end

end
