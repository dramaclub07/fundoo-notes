FactoryBot.define do
  factory :user do
    name { "Test User" }
    email { "test@example.com" }
    # email { Faker::Internet.unique.email }
    phone_number { Faker::Number.number(digits: 10) }
    password { "P@ssw0rd" }
    password_confirmation { "P@ssw0rd" } # Required due to has_secure_password
  end
end
