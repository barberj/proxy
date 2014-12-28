FactoryGirl.define do
  factory :user do
    first_name "External"
    last_name "User"
    sequence(:email) { |n| "external#{n}@testing.com"}
    password "password"
    last_signin_at "2014-12-26 21:26:34"
    account
  end

end
