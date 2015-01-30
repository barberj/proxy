class V1::UsersController < ApiController
  include V1::ApiAuthorization

  skip_before_action :authorize_user!, :only => [:create]

  def show
    render json: {user: user}, status: :ok
  end

  def create
    user = User.new(create_params)
    status = if user.valid?
      user.account = Account.create
      user.save
      :created
    else
      :bad_request
    end

    render json: user.errors, status: status
  end

  def update
    user.update(update_params)
    render json: user, status: status
  end

private

  def subscribe_user
    rsp = Braintree::Customer.create(billing_params)
    if rsp.success?
      token = rsp.customer.credit_cards[0].token
      Braintree::Subscription.create(
        :payment_method_token => token,
        :plan_id              => "beta_one"
      )
      rsp.customer.id
    else
      Rails.logger.error(rsp.message)
      nil
    end
  end

  def billing_params
    params.except(:utf8, :authenticity_token, :controller, :action, :password, :interested_api)
  end

  def create_params
    params.require(:email)
    params.require(:password)

    params.permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :interested_api
    )
  end

  def update_params
    params.permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :interested_api
    )
  end
end
