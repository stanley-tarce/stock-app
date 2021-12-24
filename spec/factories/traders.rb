name = Faker::Name.name
wallet = Faker::Number.decimal(l_digits: 6)
email = name.downcase.gsub(' ', '_') + '@yahoo.com'
FactoryBot.define do
  factory :trader do
    name { name }
    email { email }
    wallet { wallet }
    status { 'pending' }
    password { 'password' }
    password_confirmation { 'password' }
    association :user, email: email, name: name
  end
end