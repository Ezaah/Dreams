FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { "#{Faker::Name.first_name}.#{Faker::Name.last_name}@email.com".downcase }
    password { Faker::Name.first_name.downcase }
    mode 0
    artefact { Faker::Number.number(8) }
    active true
  end
end
