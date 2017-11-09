FactoryBot.define do
  factory :measurement do
    user_id nil
    light { Faker::Number.between(0,1023) }
    sound { Faker::Number.between(0,1) }
    temperature { Faker::Number.between(0,100) }
    humidity { Faker::Number.between(0,100) }
    active true
  end
end
