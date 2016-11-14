FactoryGirl.define do
  factory :team do
    name { Faker::Lorem.words }

    trait :with_users do
      after(:build) do |team|
        2.times do
          team.users << create(:user)
        end
      end
    end
  end
end
