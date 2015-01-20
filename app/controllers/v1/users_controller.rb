class V1::UsersController < ApiController
  include V1::ApiAuthorization
  skip_before_action :authorize_user!, :only => [:create]

  def create
    if billing_id = subscribe_user
      user = User.new(create_params.merge(billing_id: billing_id))
      status = if user.valid?
        user.account = Account.create
        user.save
        :created
      else
        :bad_request
      end
    else
    end

    render json: user.errors, status: status
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
    params.require(:first_name)
    params.require(:last_name)
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
end
