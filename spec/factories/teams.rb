FactoryGirl.define do
  factory :team do
    name { Faker::Lorem.words }
    factory :team_with_users do
      transient do
        users_count 2
      end

      after(:create) do |team, evaluator|
        (0...evaluator.users_count).each do |u|
          team.users << FactoryGirl.create(:user)
        end
      end
    end
  end
end
