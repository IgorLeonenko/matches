FactoryGirl.define do
  factory :match do
    name  { Faker::Lorem.characters(10) }
  end
end
