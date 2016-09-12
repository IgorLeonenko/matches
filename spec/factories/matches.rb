FactoryGirl.define do
  factory :match do
    name  { Faker::Team.name }
  end
end
