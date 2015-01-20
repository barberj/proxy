if Rails.env.production?
  Braintree::Configuration.environment = :production
  Braintree::Configuration.merchant_id = '8bf4t6nhrgtyvfj6'
  Braintree::Configuration.public_key = '62mj5v9jtst43gh4'
  Braintree::Configuration.private_key = '85071a482cfc06e572d8c78146ba176b'
else
  Braintree::Configuration.environment = :sandbox
  Braintree::Configuration.merchant_id = 'r7wrt8f78k95wwtp'
  Braintree::Configuration.public_key = 'r79wqwhpn92r56ss'
  Braintree::Configuration.private_key = '195b906eda40432f0b082b6bdef57c10'
end
