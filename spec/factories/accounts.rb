FactoryGirl.define do
  factory :account do
    after(:create) do |account|
      create(:user, :account => account)
    end
  end
end
