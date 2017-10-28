FactoryBot.define do
  factory :measurement do
    user_id nil
    light { Faker::Number.between(0,1024) }
    sound { Faker::Number.between(0,1024) }
    temperature { Faker::Number.between(0,100) }
    humidity { Faker::Number.between(0,100) }
    active true
    measured_at { Faker::Date.between(1.days.ago, Date.today) }
  end
end
